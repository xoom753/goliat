require "rails_helper"

RSpec.describe PersonEjeResumenRenderService do
  let(:resumen) do
    PersonEjesResumen.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: "02/01/2020\t30/06/2020\n01/07/2020\t31/12/2020"
    )
  end

  subject(:service) { described_class.new(resumen) }

  it "builds common identity and sentence rows" do
    expect(service.common_table_rows).to include(
      ["NOMBRE:", "CASEY EXAMPLE"],
      ["CÉDULA DE IDENTIDAD:", "1234567890"],
      ["FECHA DE PÉRDIDA DE LIBERTAD:", "02/01/2020"],
      ["DELITO:", "Robo"],
      ["SENTENCIA:", "Sentencia A"]
    )
  end

  it "builds date ranges by percentage from period details" do
    expect(service.periodos_porcentuales).to eq(
      "20%" => [{ start_date: "02/01/2020", end_date: "30/06/2020" }],
      "40%" => [{ start_date: "01/07/2020", end_date: "31/12/2020" }]
    )
  end

  it "caches common table rows" do
    expect(service.common_table_rows).to equal(service.common_table_rows)
  end
end
