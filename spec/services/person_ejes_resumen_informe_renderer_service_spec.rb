require "rails_helper"

RSpec.describe PersonEjesResumen::InformeRendererService do
  let(:summary) do
    PersonEjesResumen.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%",
      periodos_detalle: "01/01/24\t30/06/24\t180\t20%",
      tipo_porcentual: true
    )
  end
  let(:docx) { double }
  let(:translator) { PersonEjesResumen::ActivityToHumanRendererService::InformesTranslator.new(kind: :cultural) }
  let(:periodos_renderer) { PersonEjesResumen::PeriodosRendererService.new(kind: :cultural, person_ejes_resumen: summary) }
  let(:activities_renderer) { double }

  it "delegates period calculation to the period renderer" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.periodos.map(&:period_percentage)).to eq(["20%"])
  end

  it "caches the period renderer result" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)
    first_periods = renderer.periodos

    expect(renderer.periodos).to equal(first_periods)
  end

  it "delegates activity and grade ficha lookup to the fichas renderer" do
    report_renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)
    activity_ficha = double("activity ficha")
    grade_ficha = double("grade ficha")
    fichas = double(get_activities_ficha: activity_ficha, get_grades_ficha: grade_ficha)
    allow(report_renderer).to receive(:fichas_renderer).and_return(fichas)

    expect(report_renderer.get_activities_ficha(0)).to equal(activity_ficha)
    expect(report_renderer.get_grades_ficha(0)).to equal(grade_ficha)
  end

  it "returns only the first ficha index for percentage reports" do
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.get_fichas_indexes).to eq([0])
  end

  it "returns one index per semester period for semester reports" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)
    allow(summary).to receive(:semestres_porcentuales).and_return("20%\n40%")
    allow(summary).to receive(:periodos_detalle).and_return(
      "01/01/24\t30/06/24\t180\t20%\n\n01/07/24\t31/12/24\t184\t40%"
    )
    renderer = described_class.new(person_ejes_resumen: summary, kind: :cultural)

    expect(renderer.get_fichas_indexes.to_a).to eq([0, 1])
  end
end
