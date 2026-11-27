require "rails_helper"

RSpec.describe ImportListadoPabellonesTask do
  let(:sheet) { double }
  let(:xlsx) { double(sheet: sheet) }
  subject(:task) { described_class.new(xlsx) }

  def stub_rows(*data_rows)
    allow(sheet).to receive(:each) do |&block|
      (Array.new(5) { |index| [ "header #{index}" ] } + data_rows.map { |value| [ value ] }).each(&block)
    end
  end

  it "skips five header rows and imports people under mapped pavilion and cell labels" do
    stub_rows(
      "PABELLON_A",
      "CELDA_A_001",
      "  CASEY EXAMPLE  ",
      "Total general"
    )

    expect { task.import! }.to output(/A\n    001/).to_stdout
    expect(PersonPabellonUpdate.count).to eq(1)
    expect(PersonPabellonUpdate.last).to have_attributes(
      nombres: "  CASEY EXAMPLE  ",
      celda: "001",
      pabellon: "A"
    )
  end

  it "maps pavilion rows that match configured aliases directly" do
    stub_rows(
      "TRANSITORIA_2",
      "CELDA_Transitoria 2_003",
      "JAMIE EXAMPLE"
    )

    expect { task.import! }.to output(/Transitoria 2\n    003/).to_stdout
    expect(PersonPabellonUpdate.last).to have_attributes(
      nombres: "JAMIE EXAMPLE",
      celda: "003",
      pabellon: "Transitoria 2"
    )
  end

  it "uses configured specific cells and pavilion-prefix mappings" do
    stub_rows(
      "PABELLON_CHOFERES_G2",
      "CELDA_Choferes_CHOF_014",
      "MORGAN RIVERA",
      "CELDA_SAN_JOSE_TRANS_001",
      "ALEX RIVERA"
    )

    expect { task.import! }.to output(/Choferes.*014.*San José Transitoria/m).to_stdout

    expect(PersonPabellonUpdate.order(:id).map { |update| [ update.nombres, update.celda, update.pabellon ] }).to eq([
      [ "MORGAN RIVERA", "014", "Choferes" ],
      [ "ALEX RIVERA", "San José Transitoria", "Choferes" ]
    ])
  end

  it "does not create records for blank rows or the total row" do
    stub_rows("TRANSITORIA_2", "CELDA_TRANSITORIA_2_002", "", "Total general")

    expect { task.import! }.to output.to_stdout

    expect(PersonPabellonUpdate.count).to eq(0)
  end
end
