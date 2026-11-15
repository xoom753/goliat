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
      periodos_detalle: periods_detail,
      tipo_porcentual: percentage_mode
    )
  end
  let(:percentage_mode) { true }

  def expect_educativo_docx(report)
    get educativo_export_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include(
      "attachment",
      "Educativo-Casey Example.docx"
    )
    expect(response.body).to start_with("PK")
  end

  describe "grades ficha rendering" do
    let(:periods_detail) { "02/01/20\t30/06/20\t180\t20%" }

    def stub_report_renderer(should_render:)
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
        get_fichas_indexes: [0], get_activities_ficha: activities_ficha,
        get_grades_ficha: grades_ficha, signature: nil, fecha_entrega: nil
      )
      allow(renderer).to receive(:docx=)
      allow(PersonEjesResumen::InformeRendererService).to receive(:new)
        .with(kind: :educativo, person_ejes_resumen: report).and_return(renderer)
      grades_ficha
    end

    it "skips grades for an old-format period" do
      grades_ficha = stub_report_renderer(should_render: false)
      expect(grades_ficha).not_to receive(:title)

      get educativo_export_person_ejes_resumen_path(report, format: :docx)

      expect(response).to have_http_status(:ok)
    end

    it "renders grades for a current-format period" do
      grades_ficha = stub_report_renderer(should_render: true)
      expect(grades_ficha).to receive(:title)

      get educativo_export_person_ejes_resumen_path(report, format: :docx)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "porcentual" do
    let(:periods_detail) do
      "02/01/20\t30/06/20\t180\t20%\n01/07/20\t31/12/20\t184\t40%"
    end

    it "renders a DOCX attachment for a percentage report" do
      expect_educativo_docx(report)
    end
  end

  describe "semestral" do
    let(:percentage_mode) { false }
    let(:periods_detail) do
      "02/01/20\t30/06/20\t180\t20%\n\n01/07/20\t31/12/20\t184\t40%"
    end

    it "renders a DOCX attachment for each semester period" do
      expect_educativo_docx(report)
    end
  end
end
