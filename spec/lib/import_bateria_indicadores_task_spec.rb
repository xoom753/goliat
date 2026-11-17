require "rails_helper"

RSpec.describe ImportBateriaIndicadoresTask do
  let(:sheet) { double }
  let(:xlsx) { double(sheet: sheet) }
  subject(:task) { described_class.new(xlsx) }

  let(:pre_headers) { Rails.application.config_for(:bateria_indicadores)[:pre_headers] }
  let(:headers) { Rails.application.config_for(:bateria_indicadores)[:headers] }

  def rows_after_headers(*data_rows)
    Array.new(6) { |index| [ "ignored header #{index}" ] } + [ *data_rows ]
  end

  it "validates configured pre-headers and headers before importing data rows" do
    allow(sheet).to receive(:row).with(5).and_return(pre_headers)
    allow(sheet).to receive(:row).with(6).and_return(headers)
    data_row = [ "row data" ] * headers.length
    allow(sheet).to receive(:each) do |&block|
      (Array.new(6) { [ "header" ] } + [ data_row ]).each(&block)
    end
    row_importer = instance_double(ImportBateriaIndicadoresTask::BateriaIndicadoresRow, import!: true, fullname: "CASEY EXAMPLE")
    expect(ImportBateriaIndicadoresTask::BateriaIndicadoresRow).to receive(:new)
      .with(data_row).and_return(row_importer)

    expect { task.import! }.to output(/imported 1 records/).to_stdout
  end

  it "raises when the pre-header row does not match the configured template" do
    allow(sheet).to receive(:row).with(5).and_return([ "wrong" ])

    expect { task.import! }.to raise_error("pre-headers wrong")
  end

  it "reports missing header values and raises when the header row is invalid" do
    allow(sheet).to receive(:row).with(5).and_return(pre_headers)
    allow(sheet).to receive(:row).with(6).and_return([ "UNKNOWN COLUMN" ])

    expect {
      expect { task.import! }.to output(/missing: \["UNKNOWN COLUMN"\]/).to_stdout
    }.to raise_error("headers wrong")
  end

  it "skips the six header rows and does not count blank person rows" do
    allow(sheet).to receive(:row).with(5).and_return(pre_headers)
    allow(sheet).to receive(:row).with(6).and_return(headers)
    data_row = Array.new(headers.length)
    allow(sheet).to receive(:each) { |&block| rows_after_headers(data_row).each(&block) }
    row_importer = instance_double(ImportBateriaIndicadoresTask::BateriaIndicadoresRow, import!: false, fullname: nil)
    expect(ImportBateriaIndicadoresTask::BateriaIndicadoresRow).to receive(:new).with(data_row).and_return(row_importer)

    expect { task.import! }.to output(/imported 0 records/).to_stdout
  end
end
