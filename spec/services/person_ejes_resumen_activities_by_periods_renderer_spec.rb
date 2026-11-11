require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesByPeriodsRendererService do
  it "fetches both activity sources and groups them into periods" do
    summary = double("summary")
    period_service = double("periods")
    legacy = [:legacy]
    present = [:present]
    grouped_result = [:period]
    legacy_fetcher = double(activities: legacy)
    present_fetcher = double(activities: present)
    grouped_renderer = double(grouped_activities: grouped_result)

    expect(PersonEjesResumen::ActivitiesFetcherService::LegacyActivitiesFetcher)
      .to receive(:new).with(kind: :cultural, person_ejes_resumen: summary).and_return(legacy_fetcher)
    expect(PersonEjesResumen::ActivitiesFetcherService::PresentActivitiesFetcher)
      .to receive(:new).with(kind: :cultural, person_ejes_resumen: summary).and_return(present_fetcher)
    expect(PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesRenderer)
      .to receive(:new).with(
        periodos_renderer_service: period_service,
        legacy_activities: legacy,
        present_activities: present
      ).and_return(grouped_renderer)

    service = described_class.new(kind: :cultural, person_ejes_resumen: summary, periodos_renderer_service: period_service)

    expect(service.grouped_activities).to eq(grouped_result)
    expect(service.grouped_activities).to equal(grouped_result)
  end
end
