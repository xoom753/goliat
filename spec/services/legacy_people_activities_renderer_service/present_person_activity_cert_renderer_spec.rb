require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::PresentPersonActivityCertRenderer do
  let(:activity) { ExtraActivity.new(nombre: "Tejido") }

  it "uses the default duration when qty_h is blank" do
    renderer = described_class.new(
      person_activity: PersonActivity.new(anio: 2024, mes: 5, coursable: activity),
      kind: :cultural
    )

    expect(renderer.duracion_str).to eq("30 horas")
    expect(renderer.get_months_and_year).to eq("mayo de 2024")
  end

  it "uses the supplied duration and identifies workshops" do
    renderer = described_class.new(
      person_activity: PersonActivity.new(anio: 2024, mes: 5, qty_h: "12", coursable: activity),
      kind: :cultural
    )

    expect(renderer.duracion_str).to eq("12 horas")
    expect(renderer.activity_kind_str).to eq("taller de")
    expect(renderer.cert_string).to include("taller de", "Tejido", "mayo de 2024", "12 horas")
  end
end
