require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesByPeriodsRendererService do
  it "uses legacy hours instead of duplicating a same-named present activity" do
    activity_group = ActivityGroup.create!(nombre: "Eje Cultural")
    legacy_group = LegacyActivityGroup.create!(nombre: "Cultural workshops", activity_group: activity_group)
    present_person = Person.create!(nombres: "Casey Example", dni: "1234567890")
    legacy_person = LegacyPerson.create!(nombres: "Casey Example")
    present_activity = Activity.create!(nombre: "Weaving", activity_group: activity_group)
    legacy_activity = LegacyActivity.create!(nombre: "Weaving")
    PersonActivity.create!(
      person: present_person,
      coursable: present_activity,
      anio: 2024,
      mes: 3,
      qty_h: "4 horas"
    )
    LegacyPersonActivity.create!(
      legacy_person: legacy_person,
      legacy_activity: legacy_activity,
      legacy_activity_group: legacy_group,
      end_date: Date.new(2024, 3, 31),
      duracion: "8 horas"
    )
    summary = PersonEjesResumen.new(
      people_ids: [ present_person.id ],
      legacy_people_ids: [ legacy_person.id ]
    )
    period = PersonEjesResumen::PeriodosWrapper::PorcentualWrapper.new(
      kind: :cultural,
      start_date: "01/03/2024",
      end_date: "31/03/2024",
      period_percentage: "20%"
    )
    service = described_class.new(
      kind: :cultural,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: [ period ])
    )

    rendered_activities = service.grouped_activities.first.activities

    expect(rendered_activities.map(&:activity_str)).to eq([ "Weaving" ])
    expect(rendered_activities.first.duracion_str).to eq("8 horas")
  end

  it "fetches both activity sources and groups them into periods" do
    summary = double("summary")
    period_service = double("periods")
    legacy = [ :legacy ]
    present = [ :present ]
    grouped_result = [ :period ]
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
