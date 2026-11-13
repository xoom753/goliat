require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::DraftFichaRenderer do
  let(:docx) { double }
  let(:summary) { double }
  let(:translator) { double }
  let(:activities_renderer) { double(grouped_activities: grouped_periods) }
  let(:grouped_periods) { [] }
  subject(:renderer) do
    described_class.new(
      kind: :cultural,
      docx: docx,
      person_ejes_resumen: summary,
      activities_by_periods_renderer_service: activities_renderer,
      informes_translator_service: translator
    )
  end

  it "writes the title and each grouped activity string" do
    first = double(activities: [ double(render_string: "Certificate A"), double(render_string: "Certificate B") ])
    second = double(activities: [ double(render_string: "Certificate C") ])
    allow(activities_renderer).to receive(:grouped_activities).and_return([ first, second ])
    expect(docx).to receive(:h1).with("Todas las actividades")
    expect(docx).to receive(:p).with("Certificate A")
    expect(docx).to receive(:p).with("Certificate B")
    expect(docx).to receive(:p).with("Certificate C")

    renderer.draft_activities_list
  end

  it "writes only the heading when no grouped activities are available" do
    expect(docx).to receive(:h1).with("Todas las actividades")
    expect(activities_renderer).to receive(:grouped_activities).and_return([])

    renderer.draft_activities_list
  end
end
