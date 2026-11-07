require "rails_helper"

RSpec.describe "Cultural report DOCX", type: :request do
  let(:report_attributes) do
    {
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: "02/01/20\t30/06/20\t180\t20%\n\n01/07/20\t31/12/20\t184\t40%",
      tipo_porcentual: true
    }
  end

  def expect_cultural_docx_download(report)
    get cultural_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Cultural-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end

  it "renders a downloadable DOCX for percentage-based summaries" do
    report = PersonEjesResumen.create!(report_attributes)

    expect_cultural_docx_download(report)
  end

  it "renders a downloadable DOCX for semester-based summaries" do
    report = PersonEjesResumen.create!(report_attributes.merge(tipo_porcentual: false))

    expect_cultural_docx_download(report)
  end
end
