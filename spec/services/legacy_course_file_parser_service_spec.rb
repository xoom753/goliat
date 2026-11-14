require "rails_helper"

RSpec.describe LegacyCourseFileParserService do
  let(:parser_config) do
    double(sheet_numbers: nil, skip_rows: 1, nombres_col: 0, file_format: "xlsx")
  end
  let(:import_file) { double(parseable: parser_config, id: 7) }
  let(:sheet) { double }
  let(:xlsx) { double }
  let(:params) do
    {
      grupo: "artes culturales",
      actividad: "tejido",
      rango: "enero a marzo",
      duracion: "12 horas",
      hasta: Date.new(2024, 3, 31),
      detalle: "tejido manual"
    }
  end
  subject(:service) { described_class.new(import_file, params: params) }

  describe "#parse!" do
    before do
      allow(service).to receive(:xlsx).and_return(xlsx)
      allow(xlsx).to receive(:sheet).with(0).and_return(sheet)
    end

    it "parses normalized records, retains header rows, and stops after the footer" do
      allow(sheet).to receive(:each).and_yield(["Nombres"]).and_yield(["ANA PEREZ"]).and_yield([nil]).and_yield(["FOOTER"])

      service.parse!

      expect(service.headers).to eq([["Nombres"]])
      expect(service.records.length).to eq(1)
      expect(service.records.first).to have_attributes(
        row_number: 2,
        nombres_str: "Ana Perez",
        activity_group_str: "Artes Culturales",
        activity_str: "Tejido",
        activity_dates: "Enero A Marzo",
        duracion: "12 horas",
        end_date: Date.new(2024, 3, 31),
        legacy_import_file_id: 7,
        activity_detail_str: "Tejido Manual"
      )
    end

    it "parses each configured sheet number" do
      allow(parser_config).to receive(:sheet_numbers).and_return("1,2")
      first_sheet = double
      second_sheet = double
      allow(xlsx).to receive(:sheet).with(1).and_return(first_sheet)
      allow(xlsx).to receive(:sheet).with(2).and_return(second_sheet)
      allow(first_sheet).to receive(:each).and_yield(["First header"])
      allow(second_sheet).to receive(:each).and_yield(["Second header"])

      service.parse!

      expect(service.headers).to eq([["First header"], ["Second header"]])
    end

    it "omits the detail when no detail parameter is supplied" do
      allow(params).to receive(:[]).and_call_original
      allow(params).to receive(:[]).with(:detalle).and_return(nil)
      allow(sheet).to receive(:each).and_yield(["Nombres"]).and_yield(["ANA PEREZ"])

      service.parse!

      expect(service.records.first.activity_detail_str).to be_nil
    end
  end

  describe "#import_records!" do
    it "saves parsed records and marks the file imported" do
      first = double
      second = double
      allow(service).to receive(:records).and_return([first, second])
      expect(first).to receive(:save!)
      expect(second).to receive(:save!)
      expect(import_file).to receive(:update!).with(status: :imported, records_count: 2, records_list: nil)

      service.import_records!
    end
  end

  describe "spreadsheet access" do
    it "opens the attached workbook using the configured format and reads the first sheet" do
      blob = double(key: "course-blob")
      allow(import_file).to receive(:file).and_return(double(attachment: double(blob: blob)))
      allow(ActiveStorage::Blob.service).to receive(:path_for).with("course-blob").and_return("/tmp/course.xlsx")
      workbook = double
      first_sheet = double
      expect(Roo::Spreadsheet).to receive(:open).with("/tmp/course.xlsx", extension: :xlsx).and_return(workbook)
      expect(workbook).to receive(:sheet).with(0).and_return(first_sheet)
      allow(first_sheet).to receive(:each).and_yield(["Names"])

      service.parse!

      expect(service.headers).to eq([["Names"]])
    end
  end
end
