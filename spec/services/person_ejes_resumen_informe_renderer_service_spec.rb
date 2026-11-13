require "rails_helper"

RSpec.describe PersonEjesResumen::InformeRendererService do
  let(:summary) do
    PersonEjesResumen.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%",
      periodos_detalle: "01/01/24\t30/06/24\t180\t20%",
      tipo_porcentual: true
    )
  end

  it "delegates period calculation to the period renderer" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.periodos.map(&:period_percentage)).to eq([ "20%" ])
  end

  it "caches the period renderer result" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.periodos).to equal(renderer.periodos)
  end
end
