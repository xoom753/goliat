require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesRenderer do
  it "converts both legacy and present records to their respective renderer types" do
    legacy_record = double("legacy record")
    present_record = double("present record")
    legacy_renderer = double("legacy renderer")
    present_renderer = double("present renderer")
    period_renderer = double("period renderer", by_periods: :periods)

    expect(PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer)
      .to receive(:new).with(current_activity: legacy_record).and_return(legacy_renderer)
    expect(PersonEjesResumen::ActivityRendererService::PresentActivityRenderer)
      .to receive(:new).with(current_activity: present_record).and_return(present_renderer)
    expect(PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesByPeriodRenderer)
      .to receive(:new).with(
        activities: [ legacy_renderer, present_renderer ],
        periodos_renderer_service: :periods_service
      ).and_return(period_renderer)

    service = described_class.new(
      legacy_activities: [ legacy_record ],
      present_activities: [ present_record ],
      periodos_renderer_service: :periods_service
    )

    expect(service.grouped_activities).to eq(:periods)
    expect(service.grouped_activities).to equal(service.grouped_activities)
  end

  it "returns grouped periods when no legacy or present activities exist" do
    period_renderer = double(by_periods: [ :empty_period ])
    allow(PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesByPeriodRenderer)
      .to receive(:new).and_return(period_renderer)

    result = described_class.new(
      legacy_activities: [],
      present_activities: [],
      periodos_renderer_service: double
    ).grouped_activities

    expect(result).to eq([ :empty_period ])
  end
end
