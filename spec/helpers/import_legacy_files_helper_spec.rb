require "rails_helper"

RSpec.describe ImportLegacyFilesHelper, type: :helper do
  describe "#q_button_filter" do
    it "marks the selected query filter active and clears the query value" do
      allow(helper).to receive(:params).and_return(
        ActionController::Parameters.new(q: "records", year: "2024", status: "uploaded")
      )
      expect(helper).to receive(:link_to).with(
        "Records",
        import_legacy_files_path(q: nil, year: "2024", status: "uploaded"),
        class: "button is-link"
      ).and_return(:link)

      expect(helper.q_button_filter("records")).to eq(:link)
    end

    it "sets an unselected query filter and preserves other filters" do
      allow(helper).to receive(:params).and_return(
        ActionController::Parameters.new(q: "records", year: "2024", status: "uploaded")
      )
      expect(helper).to receive(:link_to).with(
        "Imported",
        import_legacy_files_path(q: "imported", year: "2024", status: "uploaded"),
        class: "button is-ghost"
      ).and_return(:link)

      expect(helper.q_button_filter("imported")).to eq(:link)
    end
  end

  describe "#year_button_filter" do
    it "marks the selected year active and clears the year value" do
      allow(helper).to receive(:params).and_return(
        ActionController::Parameters.new(q: "records", year: "2024", status: "uploaded")
      )
      expect(helper).to receive(:link_to).with(
        2024,
        import_legacy_files_path(q: "records", year: nil, status: "uploaded"),
        class: "button is-link"
      ).and_return(:link)

      expect(helper.year_button_filter(2024)).to eq(:link)
    end

    it "sets an unselected year and preserves the query and status filters" do
      allow(helper).to receive(:params).and_return(
        ActionController::Parameters.new(q: "records", year: "2024", status: "uploaded")
      )
      expect(helper).to receive(:link_to).with(
        2025,
        import_legacy_files_path(q: "records", year: 2025, status: "uploaded"),
        class: "button is-ghost"
      ).and_return(:link)

      expect(helper.year_button_filter(2025)).to eq(:link)
    end
  end
end
