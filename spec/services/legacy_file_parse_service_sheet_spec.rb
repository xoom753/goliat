require "rails_helper"

RSpec.describe LegacyFileParseService do
  describe "#sheet" do
    it "opens the attached file using the configured format and worksheet name" do
      parser = double(file_format: "xlsx", sheet_name: "People")
      blob = double(key: "blob-key")
      attachment = double(blob: blob)
      attached_file = double(attachment: attachment)
      import_file = double(parseable: parser, file: attached_file)
      service = described_class.new(import_file)
      sheet = double
      workbook = double
      allow(ActiveStorage::Blob.service).to receive(:path_for).with("blob-key").and_return("/tmp/people.xlsx")
      expect(Roo::Spreadsheet).to receive(:open).with("/tmp/people.xlsx", extension: :xlsx).and_return(workbook)
      expect(workbook).to receive(:sheet).with("People").and_return(sheet)

      expect(service.send(:sheet)).to equal(sheet)
    end
  end
end
