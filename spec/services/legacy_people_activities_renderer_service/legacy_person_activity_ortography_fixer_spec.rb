require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer do
  describe "#fix_ortography" do
    it "replaces known misspellings and capitalization" do
      expect(subject.fix_ortography("Panaderia")).to eq("Panadería")
      expect(subject.fix_ortography("Pabellon")).to eq("Pabellón")
    end

    it "returns words that are not in the correction dictionary unchanged" do
      expect(subject.fix_ortography("desconocida")).to eq("desconocida")
    end
  end
end
