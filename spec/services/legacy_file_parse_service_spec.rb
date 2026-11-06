require "rails_helper"

RSpec.describe LegacyFileParseService do
  let(:parser) do
    double(
      start_date_index_from: 0,
      start_date_index_to: 10,
      end_date_index_from: 13,
      end_date_index_to: 23,
      row_number: "Row",
      nombres: "Name",
      activity_group_str: "Services",
      activity_str: "Activity",
      activity_dates: "Dates",
      duracion: "Duration",
      activity_detail_str: "Detail",
      file_format: "xlsx",
      sheet_name: "Sheet1"
    )
  end
  let(:import_file) { double(parseable: parser, id: 9, override_hasta: override_hasta) }
  let(:override_hasta) { nil }
  subject(:service) { described_class.new(import_file) }

  describe "#records" do
    it "builds records from rows after the header and normalizes their attributes" do
      sheet = double
      allow(service).to receive(:sheet).and_return(sheet)
      allow(sheet).to receive(:each).and_yield({}).and_yield(
        row_number: 4,
        nombres: "  ana perez ",
        servicios: " artes culturales ",
        actividad: " tejido ",
        fecha: " 01/01/2024 - 31/03/2024 ",
        duracion: " 12 horas ",
        activity_detail: " detalle manual "
      )

      expect(service.records.first).to have_attributes(
        row_number: 4,
        nombres_str: "Ana Perez",
        activity_group_str: "Artes Culturales",
        activity_str: "Tejido",
        activity_detail_str: "Detalle Manual",
        start_date: Date.new(2024, 1, 1),
        end_date: Date.new(2024, 3, 31),
        duracion: "12 horas",
        legacy_import_file_id: 9
      )
    end

    it "uses the activity group for a blank activity and honors override_hasta" do
      allow(import_file).to receive(:override_hasta).and_return(Date.new(2024, 4, 30))
      sheet = double
      allow(service).to receive(:sheet).and_return(sheet)
      allow(sheet).to receive(:each).and_yield({}).and_yield(
        row_number: 1,
        nombres: "ana perez",
        servicios: "deportes",
        actividad: "",
        fecha: "01/01/2024 - 31/03/2024",
        duracion: nil,
        activity_detail: nil
      )

      record = service.records.first

      expect(record.activity_str).to eq("Deportes")
      expect(record.end_date).to eq(Date.new(2024, 4, 30))
      expect(record.duracion).to eq("")
      expect(record.activity_detail_str).to eq("")
    end

    it "returns an empty list when the spreadsheet headers are missing" do
      sheet = double
      allow(service).to receive(:sheet).and_return(sheet)
      allow(sheet).to receive(:each).and_raise(Roo::HeaderRowNotFoundError)

      expect(service.records).to eq([])
    end
  end

  describe "#sheet_headers" do
    it "maps configured columns to parser headers and includes the optional detail column" do
      expect(service.send(:sheet_headers)).to eq(
        row_number: "Row",
        nombres: "Name",
        servicios: "Services",
        actividad: "Activity",
        fecha: "Dates",
        duracion: "Duration",
        activity_detail: "Detail"
      )
    end

    it "omits the optional activity detail header when it is blank" do
      allow(parser).to receive(:activity_detail_str).and_return(nil)

      expect(service.send(:sheet_headers)).not_to have_key(:activity_detail)
    end
  end

  describe "#import_records!" do
    it "saves parsed records and updates the import file summary" do
      first = double
      second = double
      allow(service).to receive(:records).and_return([first, second])
      expect(first).to receive(:save!)
      expect(second).to receive(:save!)
      expect(import_file).to receive(:update!).with(
        status: :imported,
        records_count: 2,
        records_list: nil
      )

      service.import_records!
    end
  end
end
