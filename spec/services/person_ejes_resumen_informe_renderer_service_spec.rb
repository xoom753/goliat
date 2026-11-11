require "rails_helper"

RSpec.describe PersonEjesResumen::InformeRendererService do
  let(:summary) do
    PersonEjesResumen.new(
      tipo_porcentual: true,
      semestres_porcentuales: "20%",
      periodos_detalle: "01/01/24\t30/06/24\t180\t20%"
    )
  end
  subject(:renderer) { described_class.new(person_ejes_resumen: summary, kind: :cultural) }

  it "exposes the configured periods" do
    expect(renderer.periodos.map(&:period_percentage)).to eq(["20%"])
  end

  it "delegates ficha indexes and builds the requested activity and grade fichas" do
    indexes = renderer.get_fichas_indexes

    expect(indexes).to eq([0])
    expect(renderer.get_activities_ficha(0)).to be_a(PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer)
    expect(renderer.get_grades_ficha(0)).to be_a(PersonEjesResumen::FichaRendererService::GradesFichaRenderer)
  end

  it "caches its fichas renderer" do
    renderer.get_fichas_indexes
    fichas_renderer = renderer.instance_variable_get(:@fichas_renderer)

    renderer.get_fichas_indexes

    expect(renderer.instance_variable_get(:@fichas_renderer)).to equal(fichas_renderer)
  end
end
