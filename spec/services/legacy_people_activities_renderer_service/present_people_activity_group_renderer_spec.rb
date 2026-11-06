require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::PresentPeopleActivityGroupRenderer do
  let(:summary) { PersonEjesResumen.new(people_ids: people_ids) }
  let(:people_ids) { nil }

  it "returns no activity details when no people are selected" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.people_activities_by_date).to eq({})
    expect(renderer.present_acts_details).to eq([])
  end

  it "groups matching present activities by end date as certificate renderers" do
    person = Person.create!(nombres: "Casey Example")
    summary.people_ids = person.id.to_s
    activity_group = ActivityGroup.create!(nombre: "Eje Cultural")
    activity = activity_group.activities.create!(nombre: "Tejido")
    end_date = Date.new(2024, 3, 31)
    PersonActivity.create!(person: person, coursable: activity, anio: 2024, mes: 3, qty_h: "8 horas")

    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)
    certificates = renderer.people_activities_by_date.fetch(end_date)

    expect(certificates.length).to eq(1)
    expect(certificates.first).to be_a(LegacyPeopleActivitiesRendererService::PresentPersonActivityCertRenderer)
    expect(renderer.present_acts_details).to eq(certificates)
  end
end
