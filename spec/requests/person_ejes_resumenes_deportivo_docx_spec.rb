require "rails_helper"

RSpec.describe "Deportivo report DOCX", type: :request do
  let(:report) do
    PersonEjesResumen.create!(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%",
      periodos_detalle: "02/01/20\t30/06/20\t180\t20%",
      tipo_porcentual: true
    )
  end

  it "renders a deportivo DOCX using the new report service" do
    expect(PersonEjesResumen::InformeRendererService).to receive(:new)
      .with(kind: :deportivo, person_ejes_resumen: report).and_call_original

    get deportivo_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("Deportivo-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end
end
