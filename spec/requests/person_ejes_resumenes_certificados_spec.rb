require "rails_helper"
require "csv"

RSpec.describe "Person Ejes Resumen certificados CSV", type: :request do
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
  let(:csv_data) do
    <<~CSV
      N,Apellidos y nombres,Tipo curso,Nombre curso,Eje tratamiento,Mes,Horas
      1,Casey Example,Curso,Tejido,CULTURAL,ENERO DE 2024,8 horas
    CSV
  end

  describe "GET /person_ejes_resumenes/:id/certificados" do
    it "sends the rendered CSV as a named attachment and updates report generation time" do
      rendered_csv = instance_double(PersonEjesCertificadosRenderService, to_csv: csv_data)
      expect(PersonEjesCertificadosRenderService).to receive(:new)
        .with(report)
        .and_return(rendered_csv)

      expect do
        get certificados_person_ejes_resumen_path(report, format: :csv)
      end.to change { report.reload.last_generated_at }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include(
        "attachment",
        "certificados-Casey Example.csv"
      )
      expect(response.body).to eq(csv_data)
      expect(CSV.parse(response.body, headers: true).first.fields).to eq([
        "1", "Casey Example", "Curso", "Tejido", "CULTURAL", "ENERO DE 2024", "8 horas"
      ])
    end

    it "returns a CSV attachment with headers when there are no certificates" do
      empty_csv = "N,Apellidos y nombres,Tipo curso,Nombre curso,Eje tratamiento,Mes,Horas\n"
      rendered_csv = instance_double(PersonEjesCertificadosRenderService, to_csv: empty_csv)
      allow(PersonEjesCertificadosRenderService).to receive(:new).and_return(rendered_csv)

      get certificados_person_ejes_resumen_path(report, format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.headers["Content-Disposition"]).to include("certificados-Casey Example.csv")
      expect(CSV.parse(response.body, headers: true).headers).to eq([
        "N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"
      ])
      expect(CSV.parse(response.body, headers: true).length).to eq(0)
    end
  end
end
