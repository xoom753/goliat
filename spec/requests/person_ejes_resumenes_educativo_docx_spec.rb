require "rails_helper"

RSpec.describe "Educativo report DOCX", type: :request do
  let(:report) do
    PersonEjesResumen.create!(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: "02/01/20\t30/06/20\t180\t20%\n01/07/20\t31/12/20\t184\t40%",
      tipo_porcentual: false
    )
  end

  it "renders a downloadable DOCX via the namespaced report renderer" do
    expect(PersonEjesResumen::InformeRendererService).to receive(:new)
      .with(kind: :educativo, person_ejes_resumen: report)
      .and_call_original

    get educativo_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Educativo-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end
end
