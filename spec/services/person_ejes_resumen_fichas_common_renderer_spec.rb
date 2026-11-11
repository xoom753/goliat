require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer do
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:first_period) do
    double(period_percentage: "20%", activities: [double(:activity)])
  end
  let(:second_period) { double(period_percentage: "40%", activities: []) }
  let(:periods) { [first_period, second_period] }
  let(:current_period) { first_period }
  let(:docx) { double }
  let(:renderer) do
    described_class.new(
      docx: docx,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      current_periodo: current_period
    )
  end
  let(:percentage_mode) { true }

  it "uses the temporal grade based on current period activity" do
    expect(renderer.send(:temp_grade)).to eq("2")
    allow(current_period).to receive(:activities).and_return([])
    expect(renderer.send(:temp_grade)).to eq("0")
  end

  it "computes percentage table columns and their activity scores" do
    expect(renderer.send(:get_header_colspan)).to eq(5)
    rows = [["Axis"], ["Headers", "20%"], ["Permanent", "0"], ["Temporary", "0"]]

    renderer.send(:concat_tipo_porcentual_rows!, rows)

    expect(rows[1]).to eq(["Headers", "20%", "40%"])
    expect(rows[2].last).to eq("0")
    expect(rows[3].last).to eq("0")
  end

  it "keeps the base column span for semester mode" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)

    expect(renderer.send(:get_header_colspan)).to eq(4)
  end
end
