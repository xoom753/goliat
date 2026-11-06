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

    it "merges separate years and courses independently" do
      activity_one = double("course one")
      activity_two = double("course two")
      a = double(year: 2023, activity: activity_one, month: 1)
      b = double(year: 2024, activity: activity_one, month: 2)
      c = double(year: 2023, activity: activity_two, month: 3)
      summary_a = double("summary a")
      summary_b = double("summary b")
      expect(InformeRendererService::SameActivitiesRenderer).to receive(:new).with([a]).ordered.and_return(double(summarised_activities: summary_a))
      expect(InformeRendererService::SameActivitiesRenderer).to receive(:new).with([c]).ordered.and_return(double(summarised_activities: summary_b))
      expect(InformeRendererService::SameActivitiesRenderer).to receive(:new).with([b]).ordered.and_return(double(summarised_activities: :year_two_summary))

      result = described_class.new([a, b, c]).grouped_activities

      expect(result).to eq([summary_a, summary_b, :year_two_summary])
    end

    it "caches the grouped result" do
      grouped_renderer = described_class.new([])

      expect(
        grouped_renderer.grouped_activities.object_id
      ).to equal(grouped_renderer.grouped_activities.object_id)
    end
  end
end
