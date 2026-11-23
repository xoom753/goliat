require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer do
  let(:docx) { double }
  let(:old_format) { false }
  let(:percentage_mode) { true }
  let(:period) { double(is_formato_antiguo?: old_format) }
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:period_type_renderer) { double(get_semestre: "20%") }
  let(:periods_renderer) { double(periodos: [ period ]) }
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

  it "delegates current-format table rendering with all percentage periods" do
    allow(period_type_renderer).to receive(:get_semestre).and_return("20%")
    social_table_renderer = double(table: :rendered_table)
    periods = [ period, double(period_percentage: "40%") ]
    allow(periods_renderer).to receive(:periodos).and_return(periods)
    table_renderer_class = PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoActualRenderer

    expect(table_renderer_class).to receive(:new).with(
      docx: docx,
      semestre: "20%",
      person_ejes_resumen: summary,
      periodos: periods
    ).and_return(social_table_renderer)

    expect(renderer.grades_table).to eq(:rendered_table)
  end

  it "delegates legacy-format table rendering to the legacy table renderer" do
    allow(period).to receive(:is_formato_antiguo?).and_return(true)
    social_table_renderer = double(table: :legacy_table)
    table_renderer_class = PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoAntiguoRenderer

    expect(table_renderer_class).to receive(:new).with(docx: docx).and_return(social_table_renderer)

    expect(renderer.grades_table).to eq(:legacy_table)
  end
end
