require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer do
  let(:current_period) { double(period_percentage: "20%", activities: current_activities) }
  let(:later_period) { double(period_percentage: "40%", activities: later_activities) }
  let(:periods) { [ current_period, later_period ] }
  let(:current_activities) { [ :activity ] }
  let(:later_activities) { [] }
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:period_type_renderer) do
    double(
      get_kind_specific_table_header_colspan: 5,
      get_semestre: "20%",
      get_subtotal_max_grade: "2",
      concat_tipo_porcentual_rows!: nil
    )
  end
  let(:docx) { double }
  let(:percentage_mode) { true }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      current_periodo: current_period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      by_tipo_periodo_renderer: period_type_renderer
    )
  end

  it "returns temporal grades based on the current period activity list" do
    expect(renderer.send(:temp_grade)).to eq("2")
    allow(current_period).to receive(:activities).and_return([])
    expect(renderer.send(:temp_grade)).to eq("0")
  end

  it "delegates the specific header span" do
    expect(renderer.send(:get_kind_specific_table_header_colspan)).to eq(5)
  end

  it "uses the period-type renderer span in semester mode" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)
    allow(period_type_renderer).to receive(:get_kind_specific_table_header_colspan).and_return(4)

    expect(renderer.send(:get_kind_specific_table_header_colspan)).to eq(4)
  end
end
