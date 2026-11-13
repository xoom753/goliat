require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::GradesFichaRenderer do
  let(:period) { double(activities: activities, semestre_str: "Primer semestre", start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 6, 30)) }
  let(:period_renderer) { double(periodos: [ period ]) }
  let(:docx) { double }
  let(:summary) { double(tipo_porcentual?: false) }
  let(:translator) { double }
  let(:activities_renderer) { double }
  let(:activities) { [ :activity ] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      kind: :cultural,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      periodos_renderer_service: period_renderer,
      activities_by_periods_renderer_service: activities_renderer,
      index: 0
    )
  end

  describe "#grades_summary" do
    it "renders the success branch when the period has activities" do
      allow(docx).to receive(:p)
      expect(renderer).to receive(:grades_si_cumple)

      renderer.grades_summary
    end

    it "renders the no-activity branch when the period is empty" do
      allow(docx).to receive(:p)
      allow(period).to receive(:activities).and_return([])
      expect(renderer).to receive(:grades_no_cumple)

      renderer.grades_summary
    end
  end
end
