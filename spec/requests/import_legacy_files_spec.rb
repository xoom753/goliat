require "rails_helper"

RSpec.describe "Import legacy files", type: :request do
  let(:import_file_attributes) do
    {
      filename: "records.xlsx",
      last_modified_at: "1700000000000",
      weight: "10"
    }
  end

  describe "POST /import_legacy_files" do
    it "creates an import entry with its uploaded file and metadata" do
      upload = Rack::Test::UploadedFile.new(
        StringIO.new("spreadsheet data"),
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        original_filename: "records.xlsx"
      )

      expect do
        post import_legacy_files_path, params: {
          file: upload,
          last_modified_at: "1700000000000",
          filename: "records.xlsx",
          origin_filepath: "/imports/records.xlsx",
          filesize: "17"
        }
      end.to change(LegacyImportFile, :count).by(1)

      expect(response).to redirect_to(action: :show)
      expect(LegacyImportFile.last.file).to be_attached
      expect(LegacyImportFile.last.filepath).to eq("/imports/records.xlsx")
    end
  end

  describe "GET /import_legacy_files/parse" do
    it "renders an import file that has no parser assigned" do
      import_file = LegacyImportFile.create!(**import_file_attributes)

      get "/import_legacy_files/parse", params: { id: import_file.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("records.xlsx")
    end

    it "parses an assigned legacy spreadsheet" do
      parser = LegacyFilesParser.create!(parser_name: "Legacy sheet")
      import_file = LegacyImportFile.create!(**import_file_attributes, parseable: parser)
      service = instance_double(LegacyFileParseService, records: [])
      expect(LegacyFileParseService).to receive(:new).with(import_file).and_return(service)

      get "/import_legacy_files/parse", params: { id: import_file.id }

      expect(response).to have_http_status(:ok)
    end

    it "parses an assigned course spreadsheet and supplies its headers" do
      parser = LegacyCourseFileParser.create!(parser_name: "Course sheet")
      import_file = LegacyImportFile.create!(**import_file_attributes, parseable: parser)
      service = instance_double(LegacyCourseFileParserService, headers: [["Names"]], records: [])
      expect(LegacyCourseFileParserService).to receive(:new)
        .with(import_file, params: kind_of(ActionController::Parameters))
        .and_return(service)
      expect(service).to receive(:parse!)

      get "/import_legacy_files/parse", params: { id: import_file.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Names")
    end
  end

  describe "PUT /import_legacy_files/update_parser" do
    it "assigns a legacy parser and redirects to its parse page" do
      parser = LegacyFilesParser.create!(parser_name: "Legacy sheet")
      import_file = LegacyImportFile.create!(**import_file_attributes)

      put "/import_legacy_files/update_parser", params: {
        id: import_file.id,
        parseable_id_and_type: "#{parser.id}_LegacyFilesParser",
        override_hasta: "2024-12-31"
      }

      expect(response).to redirect_to(action: :parse, id: import_file.id.to_s)
      expect(import_file.reload).to have_attributes(
        parseable_id: parser.id,
        parseable_type: "LegacyFilesParser",
        override_hasta: Date.new(2024, 12, 31)
      )
    end
  end

  describe "POST /import_legacy_files/ignore_file" do
    it "marks a file ignored and returns to the listing" do
      import_file = LegacyImportFile.create!(**import_file_attributes)

      post "/import_legacy_files/ignore_file", params: { id: import_file.id }

      expect(response).to redirect_to(action: :show)
      expect(import_file.reload).to be_ignored
    end
  end

  describe "POST /import_legacy_files/remove_file" do
    it "purges the attachment and marks the file removed" do
      import_file = LegacyImportFile.create!(**import_file_attributes)
      import_file.file.attach(io: StringIO.new("spreadsheet"), filename: "records.xlsx")

      post "/import_legacy_files/remove_file", params: { id: import_file.id }

      expect(response).to redirect_to(action: :show)
      expect(import_file.reload).to be_file_removed
      expect(import_file.file).not_to be_attached
    end
  end

  describe "POST /import_legacy_files/update_dates" do
    it "updates the imported file year and month" do
      import_file = LegacyImportFile.create!(**import_file_attributes, year: 2023, month: 1)

      post "/import_legacy_files/update_dates", params: { id: import_file.id, year: "2024", month: "5" }

      expect(response).to redirect_to(action: :show)
      expect(import_file.reload).to have_attributes(year: 2024, month: 5)
    end
  end

  describe "POST /import_legacy_files/import_records" do
    it "returns to the listing when the file has no parser assigned" do
      import_file = LegacyImportFile.create!(**import_file_attributes)

      post "/import_legacy_files/import_records", params: { id: import_file.id }

      expect(response).to redirect_to(action: :show)
    end

    it "dispatches legacy file parsers to LegacyFileParseService" do
      parser = LegacyFilesParser.create!(parser_name: "Legacy sheet")
      import_file = LegacyImportFile.create!(**import_file_attributes, parseable: parser)
      service = instance_double(LegacyFileParseService)
      expect(LegacyFileParseService).to receive(:new).with(import_file).and_return(service)
      expect(service).to receive(:import_records!)

      post "/import_legacy_files/import_records", params: { id: import_file.id }

      expect(response).to redirect_to(action: :show)
    end

    it "parses and imports course-file parser records through LegacyCourseFileParserService" do
      parser = LegacyCourseFileParser.create!(parser_name: "Course sheet")
      import_file = LegacyImportFile.create!(**import_file_attributes, parseable: parser)
      service = instance_double(LegacyCourseFileParserService)
      expect(LegacyCourseFileParserService).to receive(:new)
        .with(import_file, params: kind_of(ActionController::Parameters))
        .and_return(service)
      expect(service).to receive(:parse!)
      expect(service).to receive(:import_records!)

      post "/import_legacy_files/import_records", params: { id: import_file.id }

      expect(response).to redirect_to(action: :show)
    end
  end
end
