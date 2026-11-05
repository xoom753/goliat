require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService do
  subject(:service) { described_class.new(instance_double(PersonEjesResumen)) }

  describe "#activities_list_for" do
    it "concatenates legacy and present activity details" do
      legacy_renderer = double(legacy_acts_details: [:legacy_activity])
      present_renderer = double(present_acts_details: [:present_activity])
      allow(service).to receive(:legacy_people_activity_group_renderer_for).with(:cultural).and_return(legacy_renderer)
      allow(service).to receive(:present_people_activity_group_renderer_for).with(:cultural).and_return(present_renderer)

      expect(service.activities_list_for(:cultural)).to eq([:legacy_activity, :present_activity])
    end
  end

  describe "#activities_by_date_for" do
    it "merges legacy and present activities on matching dates" do
      date = Date.new(2024, 6, 30)
      legacy_renderer = double(people_activities_by_date: { date => [:legacy_activity] })
      present_renderer = double(people_activities_by_date: { date => [:present_activity] })
      allow(service).to receive(:legacy_people_activity_group_renderer_for).with(:laboral).and_return(legacy_renderer)
      allow(service).to receive(:present_people_activity_group_renderer_for).with(:laboral).and_return(present_renderer)

      expect(service.activities_by_date_for(:laboral)).to eq(
        date => [:legacy_activity, :present_activity]
      )
    end

    it "retains dates that occur in only one source" do
      legacy_date = Date.new(2023, 12, 31)
      present_date = Date.new(2024, 1, 31)
      legacy_renderer = double(people_activities_by_date: { legacy_date => [:legacy_activity] })
      present_renderer = double(people_activities_by_date: { present_date => [:present_activity] })
      allow(service).to receive(:legacy_people_activity_group_renderer_for).with(:deportivo).and_return(legacy_renderer)
      allow(service).to receive(:present_people_activity_group_renderer_for).with(:deportivo).and_return(present_renderer)

      expect(service.activities_by_date_for(:deportivo)).to eq(
        legacy_date => [:legacy_activity],
        present_date => [:present_activity]
      )
    end
  end
end
