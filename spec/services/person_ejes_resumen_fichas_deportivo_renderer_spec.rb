require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasDeportivoRenderer do
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:period) do
    double(
      period_percentage: "20%",
      activities: activities,
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 6, 30)
    )
  end
  let(:periods) { [period, double(period_percentage: "40%", activities: [])] }
  let(:docx) { double }
  let(:percentage_mode) { false }
  let(:activities) { [] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      current_periodo: period
    )
  end

  it "builds the deportivo grades table for semester mode" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)
    expect(docx).to receive(:table) do |rows, &block|
      expect(rows[0]).to eq(["DEPORTIVO"])
      expect(rows[1].last).to eq("20%")
      expect(rows[3]).to include("TEMPORAL", "0")
      expect(rows.last).to include("Subtotal", "5", "0")
    end
    allow(docx).to receive(:p)

    renderer.grades_table
  end

  it "builds extra percentage columns and reflects later-period activity scores" do
    allow(summary).to receive(:tipo_porcentual?).and_return(true)
    allow(periods.last).to receive(:activities).and_return([:activity])
    expect(docx).to receive(:table) do |rows, &block|
      expect(rows[1][2, 2]).to eq(["20%", "40%"])
      expect(rows[3][-1]).to eq("2")
    end
    allow(docx).to receive(:p)

    renderer.grades_table
  end
end
