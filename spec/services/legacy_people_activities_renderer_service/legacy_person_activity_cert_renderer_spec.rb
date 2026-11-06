require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::LegacyPersonActivityCertRenderer do
  subject(:renderer) do
    described_class.new(
      legacy_person_activity: LegacyPersonActivity.new(
        duracion: "8 HORAS",
        end_date: Date.new(2024, 3, 31),
        legacy_activity: LegacyActivity.new(nombre: "Panaderia")
      ),
      kind: :cultural
    )
  end

  it "formats the activity name, month, and duration for its certificate" do
    expect(renderer.actividad_str).to eq("Panadería")
    expect(renderer.month).to eq(3)
    expect(renderer.year).to eq(2024)
    expect(renderer.get_months_and_year).to eq("marzo de 2024")
    expect(renderer.duracion_str).to eq("8 horas")
  end

  it "builds the certificate sentence from the activity category" do
    expect(renderer.cert_string).to include("Panadería", "marzo de 2024", "8 horas")
  end
end
