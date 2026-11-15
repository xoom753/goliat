require "rails_helper"

RSpec.describe "Laboral and educativo grade ficha renderers" do
  let(:docx) { double }
  let(:periods) { [ current_period, later_period ] }
  let(:current_period) { double(period_percentage: "20%", activities: []) }
  let(:later_period) { double(period_percentage: "40%", activities: later_activities) }
  let(:later_activities) { [] }
  let(:period_type_renderer) do
    double(
      get_kind_specific_table_header_colspan: 5,
      get_semestre: "20%",
      get_subtotal_max_grade: "5",
      concat_tipo_porcentual_rows!: nil
    )
  end
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:percentage_mode) { false }

  def build_renderer(kind)
    renderer_class = "PersonEjesResumen::SpecificFichaRendererService::Fichas#{kind.to_s.capitalize}Renderer".constantize
    renderer_class.new(
      docx: docx,
      current_periodo: current_period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      by_tipo_periodo_renderer: period_type_renderer
    )
  end

  def render_grades_table(renderer, expected_rows:)
    allow(renderer).to receive(:column_widths)
    allow(renderer).to receive(:border_size)
    allow(renderer).to receive(:cell_style)
    allow(renderer).to receive(:cols).and_return([ :first_column ])
    allow(renderer).to receive(:rows).and_return(Array.new(expected_rows.length) { Array.new(8, :cell) })
    allow(renderer).to receive(:cells).and_return(:all_cells)
    allow(docx).to receive(:p)
    expect(docx).to receive(:table) do |rows, &block|
      expect(rows).to eq(expected_rows)
      renderer.instance_exec(&block)
    end
    expect(renderer).to receive(:cell_style).with(:first_column, bold: true)
    renderer.grades_table
  end

  describe PersonEjesResumen::SpecificFichaRendererService::FichasLaboralRenderer do
    it "builds semester rows and styles permanent and temporal sections" do
      renderer = build_renderer(:laboral)
      rows = [
        [ "LABORAL" ],
        [ "ACTIVIDADES", "DETALLES DE ACTIVIDADES", "PARÁMETROS DE CALIFICACIÓN", "MÁX", "20%" ],
        [ "PERMANENTE", "Proyectos institucionales y/o producción en talleres", "Cumplimiento a los horarios, convivencia, protocolos de seguridad y conocimientos", "3", "0" ],
        [ "TEMPORAL", "Actividades ocupacionales, capacitación, servicios auxiliares y terapia ocupacional", "Asistencia, cumplimiento a los horarios, comportamiento, protocolos de seguridad, aprobación y conocimiento", "2", "0" ],
        [ "Subtotal", "5", "0" ]
      ]

      render_grades_table(renderer, expected_rows: rows)
    end

    it "omits permanent rows and delegates percentage extension" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      allow(later_period).to receive(:activities).and_return([ :activity ])
      renderer = build_renderer(:laboral)
      allow(period_type_renderer).to receive(:get_subtotal_max_grade).and_return("2")
      expect(period_type_renderer).to receive(:concat_tipo_porcentual_rows!) do |rows|
        rows[1] << "40%"
        rows[2] << "2"
        rows[3] << "2"
      end
      rows = [
        [ "LABORAL" ],
        [ "ACTIVIDADES", "DETALLES DE ACTIVIDADES", "PARÁMETROS DE CALIFICACIÓN", "MÁX", "20%", "40%" ],
        [ "TEMPORAL", "Actividades ocupacionales, capacitación, servicios auxiliares y terapia ocupacional", "Asistencia, cumplimiento a los horarios, comportamiento, protocolos de seguridad, aprobación y conocimiento", "2", "0", "2" ],
        [ "Subtotal", "2", "0", "2" ]
      ]

      render_grades_table(renderer, expected_rows: rows)
    end
  end

  describe PersonEjesResumen::SpecificFichaRendererService::FichasEducativoRenderer do
    it "builds semester rows including both permanent education categories" do
      renderer = build_renderer(:educativo)
      rows = [
        [ "EDUCATIVO" ],
        [ "PARÁMETROS DE CALIFICACIÓN", "MÁX", "20%" ],
        [ "PERMANENTE", "EDUCACIÓN ESCOLARIZADA", "Docentes voluntarios por periodo académico; o estudiantes regulares en alfabetización, post-alfabetización, educación básica superior, bachillerato general unificado y bachillerato técnico.", "5", "0" ],
        [ "", "EDUCACIÓN SUPERIOR", "Diferentes carreras universitarias.", "", "" ],
        [ "TEMPORAL", "EDUCACIÓN NO ESCOLARIZADA", "Tutorías, cursos, talleres, charlas, biblioteca y otras actividades de capacitación recibidas.", "2", "0" ],
        [ "Subtotal", "7", "0" ]
      ]

      render_grades_table(renderer, expected_rows: rows)
    end

    it "uses the percentage subtotal maximum and delegates additional columns" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      renderer = build_renderer(:educativo)
      expect(period_type_renderer).to receive(:concat_tipo_porcentual_rows!) do |rows|
        rows[1] << "40%"
        rows[2] << "0"
        rows[3] << "0"
      end
      rows = [
        [ "EDUCATIVO" ],
        [ "PARÁMETROS DE CALIFICACIÓN", "MÁX", "20%", "40%" ],
        [ "TEMPORAL", "EDUCACIÓN NO ESCOLARIZADA", "Tutorías, cursos, talleres, charlas, biblioteca y otras actividades de capacitación recibidas.", "2", "0", "0" ],
        [ "Subtotal", "2", "0", "0" ]
      ]

      render_grades_table(renderer, expected_rows: rows)
    end
  end
end
