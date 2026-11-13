require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasDeportivoRenderer do
  let(:current_period) { double(period_percentage: "20%", activities: []) }
  let(:later_period) { double(period_percentage: "40%", activities: later_activities) }
  let(:later_activities) { [] }
  let(:periods) { [current_period, later_period] }
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
  let(:percentage_mode) { false }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      current_periodo: current_period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      by_tipo_periodo_renderer: period_type_renderer
    )
  end

  it "renders semester table rows and zero temporal score" do
    allow(docx).to receive(:p)
    expect(docx).to receive(:table) do |rows, &_block|
      expect(rows[0]).to eq(["DEPORTIVO"])
      expect(rows[1].last).to eq("20%")
      expect(rows[3]).to include("TEMPORAL", "0")
    end

    renderer.grades_table
  end

  it "delegates percentage row extension and renders resulting columns" do
    allow(summary).to receive(:tipo_porcentual?).and_return(true)
    expect(period_type_renderer).to receive(:concat_tipo_porcentual_rows!) do |rows|
      rows[1] << "40%"
      rows[2] << "0"
      rows[3] << "2"
    end
    allow(later_period).to receive(:activities).and_return([:activity])
    allow(docx).to receive(:p)
    expect(docx).to receive(:table) do |rows, &_block|
      expect(rows[1][2, 2]).to eq(["20%", "40%"])
      expect(rows[3].last).to eq("2")
    end

    renderer.grades_table
  end
end
