require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::GroupedActivitiesCertRenderer do
  it "aggregates durations and formats all included months" do
    activities = [
      double(kind: :cultural, year: 2024, month: 1, duracion: "3", actividad_str: "Tejido"),
      double(kind: :cultural, year: 2024, month: 2, duracion: "5", actividad_str: "Tejido")
    ]
    renderer = described_class.new(person_activities: activities)

    expect(renderer.duracion).to eq("8 horas")
    expect(renderer.duracion_str).to eq("8 horas")
    expect(renderer.get_months_and_year).to eq("enero y febrero de 2024")
    expect(renderer.get_months_and_year(upcase: true)).to eq("ENERO y FEBRERO de 2024")
    expect(renderer.cert_string).to include("enero y febrero de 2024", "8 horas")
  end
end
