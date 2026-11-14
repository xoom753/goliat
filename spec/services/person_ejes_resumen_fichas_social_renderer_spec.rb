require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer do
  let(:docx) { double }
  let(:old_format) { false }
  let(:percentage_mode) { true }
  let(:period) { double(is_formato_antiguo?: old_format) }
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:period_type_renderer) { double(get_semestre: "20%") }
  let(:periods_renderer) { double(periodos: [period]) }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      current_periodo: period,
      person_ejes_resumen: summary,
      periodos_renderer_service: periods_renderer,
      by_tipo_periodo_renderer: period_type_renderer
    )
  end

  let(:translated_rows) do
    {
      "person_ejes_resumen.social_report.permanente_disciplina" => "Permanent discipline",
      "person_ejes_resumen.social_report.permanente_respeto" => "Permanent respect",
      "person_ejes_resumen.social_report.permanente_comportamiento" => "Permanent behavior",
      "person_ejes_resumen.social_report.temporal_capacitaciones" => "Temporary training",
      "person_ejes_resumen.social_report.temporal_participacion" => "Temporary participation",
      "person_ejes_resumen.social_report.permanente_apoyo" => "Permanent support",
      "person_ejes_resumen.social_report.permanente_participacion" => "Permanent participation"
    }
  end

  before do
    allow(I18n).to receive(:t).and_call_original
    translated_rows.each { |key, value| allow(I18n).to receive(:t).with(key).and_return(value) }
  end

  def render_table_and_run_styles
    allow(renderer).to receive(:cell_style)
    expect(docx).to receive(:table) do |table_rows, &style_block|
      allow(renderer).to receive(:rows).and_return(table_rows)
      allow(renderer).to receive(:cols).and_return(table_rows.transpose)
      allow(renderer).to receive(:column_widths)
      allow(renderer).to receive(:border_size)
      renderer.instance_exec(&style_block)
      table_rows
    end
  end

  it "renders the current percentage-format social table and percentage scores" do
    allow(period_type_renderer).to receive(:get_semestre).and_return("20%")
    render_table_and_run_styles

    expect(renderer.grades_table).to eq([
      ["ACTIVIDADES", "DETALLES DE ACTIVIDADES", "PUNTAJE", "20%", "JUSTIFICACIÓN DE LA CALIFICACIÓN"],
      ["Permanent discipline", "Permanent respect", "0,50 puntos", "0,50", "Sí cumple"],
      ["Permanent discipline", "Permanent behavior", "0,50 puntos", "0,50", "Sí cumple"],
      ["Temporary training", "Temporary participation", "0,50 puntos", "0,50", "Charlas motivacionales individuales"],
      ["Permanent support", "Permanent participation", "0,50 puntos", "0,50", "Orientaciones psicológicas grupales"]
    ])
  end

  it "uses semester scores in the current-format table for semester reports" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)
    render_table_and_run_styles

    rows = renderer.grades_table

    expect(rows[3][2..3]).to eq(["2 puntos", "1"])
    expect(rows[4][2..3]).to eq(["2 puntos", "1"])
  end

  it "renders and styles the legacy-format table" do
    allow(period).to receive(:is_formato_antiguo?).and_return(true)
    render_table_and_run_styles
    expect(renderer).to receive(:cell_style).with(anything, bold: true, align: :center).at_least(:once)
    expect(renderer).to receive(:cell_style).with(anything, rowspan: 5, vertical_align: :center).twice

    rows = renderer.grades_table

    expect(rows.first).to eq(["ÁREAS", "PARÁMETROS", "PUNTUACIÓN", "CALIFICACIÓN", "TOTAL POR ÁREA"])
    expect(rows.length).to eq(6)
    expect(rows[1]).to eq([
      "RELACIONES INTERPERSONALES - 2,5 PUNTOS",
      "Asistencia a terapias individuales o grupales",
      "0,50",
      "0,50",
      "2,5"
    ])
  end
end
