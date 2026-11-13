require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasDeportivoRenderer do
  let(:current_period) { double(period_percentage: "20%", activities: []) }
  let(:later_period) { double(period_percentage: "40%", activities: later_activities) }
  let(:later_activities) { [] }
  let(:periods) { [current_period, later_period] }
  let(:person_summary) { double(tipo_porcentual?: percentage_mode) }
  let(:percentage_mode) { false }
  let(:docx) { double }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      person_ejes_resumen: person_summary,
      periodos_renderer_service: double(periodos: periods),
      current_periodo: current_period
    )
  end

  describe "#grades_table" do
    it "renders the semester table with the current period and zero temporal score" do
      allow(docx).to receive(:p)
      expect(docx).to receive(:table) do |rows, &_block|
        expect(rows[0]).to eq(["DEPORTIVO"])
        expect(rows[1].last).to eq("20%")
        expect(rows[3]).to include("TEMPORAL", "0")
        expect(rows.last).to include("Subtotal", "5", "0")
      end

      renderer.grades_table
    end

    it "adds remaining percentage headings and awards points to populated later periods" do
      allow(person_summary).to receive(:tipo_porcentual?).and_return(true)
      allow(later_period).to receive(:activities).and_return([:activity])
      allow(docx).to receive(:p)
      expect(docx).to receive(:table) do |rows, &_block|
        expect(rows[1][2, 2]).to eq(["20%", "40%"])
        expect(rows[3][-1]).to eq("2")
        expect(rows.last[-1]).to eq("2")
      end

      renderer.grades_table
    end
  end
end
