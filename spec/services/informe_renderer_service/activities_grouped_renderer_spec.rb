require "rails_helper"

RSpec.describe InformeRendererService::ActivitiesGroupedRenderer do
  describe "#grouped_activities" do
    it "returns an empty list when there are no activities" do
      expect(described_class.new([]).grouped_activities).to eq([])
    end

    it "groups activities by year and course before summarizing" do
      activity = double("course")
      first_month = double(year: 2024, activity: activity, month: 1)
      second_month = double(year: 2024, activity: activity, month: 2)
      renderer = instance_double(InformeRendererService::SameActivitiesRenderer, summarised_activities: :summary)
      allow(InformeRendererService::SameActivitiesRenderer).to receive(:new).with([first_month, second_month]).and_return(renderer)

      result = described_class.new([first_month, second_month]).grouped_activities

      expect(result).to eq([:summary])
    end

    it "caches the grouped result" do
      grouped_renderer = described_class.new([])

      expect(grouped_renderer.grouped_activities).to equal(grouped_renderer.grouped_activities)
    end
  end
end
