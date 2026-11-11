require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::DraftFichaRenderer do
  let(:docx) { double }
  let(:summary) { double }
  let(:translator) { double }
  let(:activity_one) { double(render_string: "Certificate one") }
  let(:activity_two) { double(render_string: "Certificate two") }
  let(:activity_group_one) { double(activities: [activity_one, activity_two]) }
  let(:activity_group_two) { double(activities: []) }
  let(:activities_renderer) { double(grouped_activities: [activity_group_one, activity_group_two]) }
  subject(:renderer) do
    described_class.new(
      kind: :cultural,
      docx: docx,
      person_ejes_resumen: summary,
      activities_by_periods_renderer_service: activities_renderer,
      informes_translator_service: translator
    )
  end

  it "writes each grouped activity as a draft paragraph" do
    expect(docx).to receive(:h1).with("Todas las actividades")
    expect(docx).to receive(:p).with("Certificate one")
    expect(docx).to receive(:p).with("Certificate two")

    renderer.draft_activities_list
  end

  it "writes the template heading" do
    expect(docx).to receive(:h1).with("(Plantillas)", align: :center)

    renderer.draft_template_title
  end

  it "renders the successful information draft using the summary renderer" do
    summary_renderer = instance_double(PersonEjesResumen::FichaRendererService::SummaryRenderer)
    allow(PersonEjesResumen::FichaRendererService::SummaryRenderer).to receive(:new).and_return(summary_renderer)
    expect(docx).to receive(:h1).with("Ficha actividades (sí cumple)")
    expect(summary_renderer).to receive(:info_si_cumple)
    expect(docx).to receive(:p)

    renderer.draft_info_si_cumple
  end
end
