require "rails_helper"

RSpec.describe "Person Ejes Resumen exports", type: :request do
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

  it "renders the social report as a DOCX attachment" do
    get social_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Social-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end

  it "renders the certificates DOCX attachment for cultural, deportivo, and laboral kinds" do
    renderer = instance_double(PersonEjesCertificadosRenderService, activities: [])
    expect(renderer).to receive(:kinds=).with([ :cultural, :deportivo, :laboral ])
    allow(PersonEjesCertificadosRenderService).to receive(:new).with(report).and_return(renderer)

    get certificados_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Certificados-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end

  it "renders the educational certificates DOCX attachment through the shared certificate template" do
    renderer = instance_double(PersonEjesCertificadosRenderService, activities: [])
    expect(renderer).to receive(:kinds=).with([ :educativo ])
    allow(PersonEjesCertificadosRenderService).to receive(:new).with(report).and_return(renderer)

    get certificados_educativo_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Certificados-Educativo-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end

  it "exports the educational certificates as a named CSV attachment" do
    renderer = instance_double(PersonEjesCertificadosRenderService, to_csv: "N,Nombre\n")
    expect(renderer).to receive(:kinds=).with([ :educativo ])
    allow(PersonEjesCertificadosRenderService).to receive(:new).with(report).and_return(renderer)

    get certificados_educativo_export_person_ejes_resumen_path(report, format: :csv)

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("text/csv")
    expect(response.headers["Content-Disposition"]).to include(
      "attachment",
      "certificados-Casey Example.csv"
    )
    expect(response.body).to eq("N,Nombre\n")
  end
end
