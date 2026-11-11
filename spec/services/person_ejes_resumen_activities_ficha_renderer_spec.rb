require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer do
  let(:current_period) do
    double(
      activities: activities,
      period_percentage: "20%",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 6, 30)
    )
  end
  let(:periods) { [current_period] }
  let(:summary) do
    double(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos_array: ["Robo"],
      sentencias_array: ["Sentencia A"],
      several_delitos?: false,
      tipo_porcentual?: percentage_mode,
      fecha_traslado: nil,
      ubicacion: "A-1"
    )
  end
  let(:translator) { double }
  let(:activities_renderer) { double(grouped_activities: grouped_periods) }
  let(:grouped_periods) { [] }
  let(:percentage_mode) { false }
  let(:activities) { [] }
  let(:docx) { double }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      kind: :cultural,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      periodos_renderer_service: double(periodos: periods),
      activities_by_periods_renderer_service: activities_renderer,
      index: 0
    )
  end

  describe "#info_summary" do
    before { allow(docx).to receive(:p) }

    it "uses the no-activity summary when the current period is empty" do
      expect(renderer).to receive(:info_no_cumple)
      renderer.info_summary
    end

    it "uses the success summary when the current period contains activities" do
      allow(current_period).to receive(:activities).and_return([:activity])
      expect(renderer).to receive(:info_si_cumple)
      renderer.info_summary
    end
  end

  describe "#info_actividades_list" do
    before do
      allow(docx).to receive(:p)
      allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
      allow(translator).to receive(:t).and_return("Localized text")
    end

    it "renders current-period certificates in semester mode" do
      activity = double(render_string: "Certificate text")
      allow(current_period).to receive(:activities).and_return([activity])
      expect(renderer).to receive(:li).with("Localized text")
      expect(renderer).to receive(:li).with("Certificate text.")

      renderer.info_actividades_list
    end

    it "renders grouped certificates across periods in percentage mode" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      activity = double(render_string: "Certificate text")
      allow(activities_renderer).to receive(:grouped_activities).and_return(
        [double(activities: [activity])]
      )
      expect(renderer).to receive(:li).with("Localized text")
      expect(renderer).to receive(:li).with("Certificate text.")

      renderer.info_actividades_list
    end

    it "renders the empty temporal activity message when there are no activities" do
      expect(renderer).to receive(:li).with("Localized text").twice

      renderer.info_actividades_list
    end
  end

  describe "#info_outro" do
    before do
      allow(docx).to receive(:p) do |*args, &block|
        renderer.instance_exec(&block) if block
      end
      allow(renderer).to receive(:text)
      allow(translator).to receive(:t).with(any_args).and_return("Translated")
    end

    it "writes a location paragraph when ubicacion is present" do
      allow(summary).to receive(:ubicacion).and_return("A-1")
      expect(docx).to receive(:p).with("Translated").ordered
      expect(docx).to receive(:p).with(no_args).ordered
      expect(docx).to receive(:p).with(no_args).ordered
      expect(docx).to receive(:p).with(no_args).ordered

      renderer.info_outro
    end

    it "writes whitespace paragraphs when ubicacion is blank" do
      allow(summary).to receive(:ubicacion).and_return(nil)
      expect(docx).to receive(:p).with("Translated").ordered
      4.times { expect(docx).to receive(:p).with(no_args).ordered }

      renderer.info_outro
    end
  end
end
