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

  def render_report_with_grades_ficha(should_render:)
    activities_ficha = double
    %i[title intro info_table info_summary info_actividades_list info_outro encargado_title].each do |method|
      allow(activities_ficha).to receive(method)
    end
    grades_ficha = double(should_render_grades_ficha?: should_render)
    %i[title intro info_table grades_table_title grades_table grades_summary encargado_title].each do |method|
      allow(grades_ficha).to receive(method)
    end
    renderer = double(
      generic_styles: nil, header: nil, footer: nil,
      draft_template_title: nil, draft_info_si_cumple: nil,
      draft_info_no_cumple: nil, draft_grades_si_cumple: nil,
      draft_grades_no_cumple: nil, draft_activities_list: nil,
      get_fichas_indexes: [ 0 ], get_activities_ficha: activities_ficha,
      get_grades_ficha: grades_ficha, signature: nil, fecha_entrega: nil
    )
    allow(renderer).to receive(:docx=)
    allow(PersonEjesResumen::InformeRendererService).to receive(:new)
      .with(kind: :deportivo, person_ejes_resumen: report).and_return(renderer)
    grades_ficha
  end

  it "skips the grades ficha when the period is old-format" do
    grades_ficha = render_report_with_grades_ficha(should_render: false)
    expect(grades_ficha).not_to receive(:title)

    get deportivo_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
  end

  it "renders the grades ficha when the period is not old-format" do
    grades_ficha = render_report_with_grades_ficha(should_render: true)
    expect(grades_ficha).to receive(:title)

    get deportivo_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
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
