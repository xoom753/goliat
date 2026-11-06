require "rails_helper"

RSpec.describe InformeRendererService do
  let(:person_renderer) do
    double(
      tipo_porcentual?: true,
      periodos_porcentuales: {
        "20%" => [{ start_date: "01/01/2024", end_date: "30/06/2024" }],
        "40%" => [{ start_date: "01/07/2024", end_date: "31/12/2024" }]
      },
      semestres_detail_hash: {}
    )
  end
  subject(:service) { described_class.new(person_renderer) }

  it "returns the first configured percentage period and key" do
    expect(service.get_first_period).to eq(start_date: "01/01/2024", end_date: "30/06/2024")
    expect(service.get_first_semestre).to eq("20%")
  end

  it "delegates report rendering to the renderer matching kind" do
    renderer = double(ficha_info_title: :rendered)
    allow(InformeRendererService::InformeCulturalRenderer).to receive(:new).with(service).and_return(renderer)
    service.kind = :cultural

    expect(service.ficha_info_title).to eq(:rendered)
  end

  it "delegates percentage settings to the person summary renderer" do
    expect(service.tipo_porcentual?).to be(true)
    expect(service.periodos_porcentuales.keys).to eq(["20%", "40%"])
  end

  describe "#legacy_person_activities_by_date" do
    it "delegates activity lookup for the selected kind" do
      activities_by_date = { Date.new(2024, 6, 30) => [:activity] }
      service.kind = :cultural
      expect(person_renderer).to receive(:activities_by_date_for).with(:cultural).and_return(activities_by_date)

      expect(service.legacy_person_activities_by_date).to eq(activities_by_date)
    end
  end

  describe "#header" do
    it "creates the document header" do
      docx = double
      service.docx = docx
      expect(docx).to receive(:header)

      service.header
    end
  end

  describe "#footer" do
    it "creates the document footer" do
      docx = double
      service.docx = docx
      expect(docx).to receive(:footer)

      service.footer
    end
  end

  describe "#signature" do
  end
end
