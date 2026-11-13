require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesByPeriodRenderer do
  it "appends each activity to every period containing its end date" do
    january_period = double(include?: true)
    march_period = double(include?: false)
    january_activity = double(end_date: Date.new(2024, 1, 31))
    march_activity = double(end_date: Date.new(2024, 3, 31))
    allow(january_period).to receive(:include?).with(Date.new(2024, 1, 31)).and_return(true)
    allow(january_period).to receive(:include?).with(Date.new(2024, 3, 31)).and_return(false)
    allow(march_period).to receive(:include?).with(Date.new(2024, 1, 31)).and_return(false)
    allow(march_period).to receive(:include?).with(Date.new(2024, 3, 31)).and_return(true)
    expect(january_period).to receive(:append).with(january_activity)
    expect(march_period).to receive(:append).with(march_activity)
    periods = [ january_period, march_period ]
    period_renderer = double(periodos: periods)

    result = described_class.new(
      activities: [ january_activity, march_activity ],
      periodos_renderer_service: period_renderer
    ).by_periods

    expect(result).to equal(periods)
  end

  it "returns periods unchanged when there are no activities" do
    periods = [ double("period") ]
    period_renderer = double(periodos: periods)

    expect(described_class.new(activities: [], periodos_renderer_service: period_renderer).by_periods).to eq(periods)
  end
end
