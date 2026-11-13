require "rails_helper"

RSpec.describe LegacyFileParseService do
  describe "#sheet" do
    it "opens the import file with its parser format and configured sheet name" do
      parser = double(file_format: "xlsx", sheet_name: "Activities")
      blob = double(key: "blob-key")
      file = double(attachment: double(blob: blob))
      import_file = double(parseable: parser, file: file)
      workbook = double
      sheet = double
      service = described_class.new(import_file)
      allow(ActiveStorage::Blob.service).to receive(:path_for).with("blob-key").and_return("/tmp/activities.xlsx")
      expect(Roo::Spreadsheet).to receive(:open).with("/tmp/activities.xlsx", extension: :xlsx).and_return(workbook)
      expect(workbook).to receive(:sheet).with("Activities").and_return(sheet)

      expect(service.send(:sheet)).to equal(sheet)
    end
  end
end
