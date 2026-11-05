require "rails_helper"

RSpec.describe InformeRendererService::SameActivitiesRenderer do
  describe "#summarised_activities" do
    it "returns the only activity when the input contains one month" do
      activity = double(month: 1)

      expect(described_class.new([activity]).summarised_activities).to equal(activity)
    end

    it "builds a grouped certificate when activities span multiple months" do
      first = double(month: 1)
      second = double(month: 2)
      grouped_certificate = double("grouped certificate")
      allow(LegacyPeopleActivitiesRendererService::GroupedActivitiesCertRenderer)
        .to receive(:new).with(person_activities: [first, second]).and_return(grouped_certificate)

      result = described_class.new([first, second]).summarised_activities

      expect(result).to equal(grouped_certificate)
    end
  end
end
