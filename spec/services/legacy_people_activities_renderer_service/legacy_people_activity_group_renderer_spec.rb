require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::LegacyPeopleActivityGroupRenderer do
  let(:summary) { PersonEjesResumen.new(legacy_people_ids: legacy_people_ids) }
  let(:legacy_people_ids) { nil }

  it "returns no activity details when no legacy people are selected" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.people_activities_by_date).to eq({})
    expect(renderer.legacy_acts_details).to eq([])
  end

  it "groups matching legacy activities by end date as certificate renderers" do
    person = LegacyPerson.create!(nombres: "Casey Example")
    summary.legacy_people_ids = person.id.to_s
    activity_group = ActivityGroup.create!(nombre: "Eje Cultural")
    legacy_group = LegacyActivityGroup.create!(nombre: "Arte", activity_group: activity_group)
    activity = LegacyActivity.create!(nombre: "Panaderia")
    end_date = Date.new(2024, 3, 31)
    LegacyPersonActivity.create!(
      legacy_person: person,
      legacy_activity_group: legacy_group,
      legacy_activity: activity,
      end_date: end_date,
      duracion: "8 horas"
    )

    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)
    certificates = renderer.people_activities_by_date.fetch(end_date)

    expect(certificates.length).to eq(1)
    expect(certificates.first).to be_a(LegacyPeopleActivitiesRendererService::LegacyPersonActivityCertRenderer)
    expect(renderer.legacy_acts_details).to eq(certificates)
  end
end
