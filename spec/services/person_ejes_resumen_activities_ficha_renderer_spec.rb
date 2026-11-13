require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer do
  let(:docx) { double }
  let(:summary) { double(nombres: "Casey Example", ubicacion: nil) }
  let(:translator) { double }
  let(:period) { double(activities: activities, period_percentage: "20%", start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 6, 30)) }
  let(:period_renderer) { double(periodos: [period]) }
  let(:activities_by_periods_renderer) { double(grouped_activities: []) }
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

  describe "#info_actividades_list" do
    before do
      allow(docx).to receive(:p)
      allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
      allow(translator).to receive(:t).with(any_args).and_return("translated")
    end

    it "renders each semester activity certificate" do
      activity = double(render_string: "Certificate detail")
      allow(period).to receive(:activities).and_return([activity])
      expect(renderer).to receive(:li).with("translated")
      expect(renderer).to receive(:li).with("Certificate detail.")

      renderer.info_actividades_list
    end

    it "uses all period groups for percentage reports" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      activity = double(render_string: "Certificate detail")
      allow(activities_by_periods_renderer).to receive(:grouped_activities).and_return(
        [double(activities: [activity])]
      )
      expect(renderer).to receive(:li).with("translated")
      expect(renderer).to receive(:li).with("Certificate detail.")

      renderer.info_actividades_list
    end

    it "lists the empty-period message when there are no activities" do
      expect(renderer).to receive(:li).with("translated").twice

      renderer.info_actividades_list
    end
  end

  describe "#info_summary" do
    before { allow(docx).to receive(:p) }

    it "selects the success message for periods with activities" do
      allow(period).to receive(:activities).and_return([:activity])
      allow(translator).to receive(:t).with(any_args).and_return("translated")
      expect(renderer).to receive(:info_si_cumple)

      renderer.info_summary
    end
  end
end
