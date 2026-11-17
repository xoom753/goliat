require "rails_helper"

RSpec.describe PersonEjesResumen::PeriodosRendererService::SemestresPorcentualesRenderer do
  let(:summary) do
    double(
      semestres_porcentuales: "40%",
      periodos_detalle: "01/01/24\t30/06/24\t180\t40%",
      primer_semestre_index: 4,
      primer_semestre_porcentaje: "30%"
    )
  end
  subject(:renderer) { described_class.new(kind: :cultural, person_ejes_resumen: summary) }

  it "starts at the configured semester index and percentage" do
    period = renderer.semestres_porcentuales.first

    expect(period.semestre_str).to eq("Cuarto semestre 30,00% al 40%")
    expect(period.period_percentage).to eq("40%")
  end

  it "defaults to the first semester and zero percent when the metadata is absent" do
    allow(summary).to receive(:primer_semestre_index).and_return(nil)
    allow(summary).to receive(:primer_semestre_porcentaje).and_return(nil)

    period = renderer.semestres_porcentuales.first

    expect(period.semestre_str).to eq("Primer semestre 0,00% al 40%")
  end

  it "memoizes the source percentage and period details" do
    expect(summary).to receive(:semestres_porcentuales).once.and_return("40%")
    expect(summary).to receive(:periodos_detalle).once.and_return("01/01/24\t30/06/24\t180\t40%")

    first_period = renderer.semestres_porcentuales.first
    second_period = renderer.semestres_porcentuales.first

    expect(first_period.semestre_str).to eq("Cuarto semestre 30,00% al 40%")
    expect(second_period.semestre_str).to eq(first_period.semestre_str)
  end
end
