require "rails_helper"

RSpec.describe "Import legacy files", type: :request do
  let(:import_file_attributes) do
    {
      filename: "records.xlsx",
      last_modified_at: "1700000000000",
      weight: "10"
    }
  end

  describe "POST /import_legacy_files/import_records" do
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
