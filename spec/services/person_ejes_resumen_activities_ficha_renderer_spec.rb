require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer do
  let(:docx) { double }
  let(:summary) { double(nombres: "Casey Example", ubicacion: nil, tipo_porcentual?: percentage_mode) }
  let(:translator) { double(t: "translated") }
  let(:period) { double(activities: activities, period_percentage: "20%", start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 6, 30)) }
  let(:period_renderer) { double(periodos: [ period ]) }
  let(:activities_by_periods_renderer) { double(grouped_activities: []) }
  let(:period_type_renderer) do
    double(
      info_actividades_permanentes_list: nil,
      info_actividades_temporales_list: nil,
      get_info_table_merged_rows_count: 3,
      ficha_info_table_bottom_rows: []
    )
  end
  let(:activities) { [] }
  let(:percentage_mode) { false }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      kind: :cultural,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      periodos_renderer_service: period_renderer,
      activities_by_periods_renderer_service: activities_by_periods_renderer,
      index: 0
    )
  end

  it "delegates activity-list rendering to the selected period-type renderer" do
    allow(renderer).to receive(:by_tipo_periodo_renderer).and_return(period_type_renderer)
    expect(period_type_renderer).to receive(:info_actividades_permanentes_list)
    expect(period_type_renderer).to receive(:info_actividades_temporales_list)

    renderer.info_actividades_list
  end

  it "selects a semestral period-type renderer for semester reports" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)

    expect(renderer.send(:by_tipo_periodo_renderer)).to be_a(
      PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosSemestralesRenderer
    )
  end

  it "selects a porcentual period-type renderer for percentage reports" do
    allow(summary).to receive(:tipo_porcentual?).and_return(true)

    expect(renderer.send(:by_tipo_periodo_renderer)).to be_a(
      PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosPorcentualesRenderer
    )
  end

  it "renders a location paragraph when the summary includes ubicacion" do
    allow(summary).to receive(:ubicacion).and_return("A-1")
    allow(translator).to receive(:t).with(any_args).and_return("Translated")
    allow(docx).to receive(:p) do |*args, &block|
      renderer.instance_exec(&block) if block
    end
    allow(renderer).to receive(:text)
    expect(docx).to receive(:p).with("Translated").ordered
    expect(docx).to receive(:p).with(no_args).ordered
    expect(docx).to receive(:p).with(no_args).ordered
    expect(docx).to receive(:p).with(no_args).ordered
    expect(renderer).to receive(:text).with("Observación.", bold: true)
    expect(renderer).to receive(:text).with(" Reside en el A-1")

    renderer.info_outro
  end

  describe "#info_summary" do
    before { allow(docx).to receive(:p) }

    it "uses the failure summary when the current period is empty" do
      expect(docx).to receive(:p).with("TRANSLATED", bold: true)
      expect(renderer).to receive(:info_no_cumple)

      renderer.info_summary
    end

    it "uses the success summary when the current period has activities" do
      allow(period).to receive(:activities).and_return([ :activity ])
      expect(docx).to receive(:p).with("TRANSLATED", bold: true)
      expect(renderer).to receive(:info_si_cumple)

      renderer.info_summary
    end
  end
end
