require "rails_helper"

RSpec.describe PersonEjesResumen::PeriodosRendererService do
  let(:summary) do
    PersonEjesResumen.new(
      tipo_porcentual: percentage_mode,
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: periods_detail
    )
  end
  let(:percentage_mode) { true }
  let(:periods_detail) { "02/01/2024\t30/06/2024\t180\t20%\n01/07/2024\t31/12/2024\t184\t40%" }
  subject(:service) { described_class.new(kind: :cultural, person_ejes_resumen: summary) }

  describe "#periodos" do
    it "returns porcentual wrappers when the report is percentage-based" do
      periods = service.periodos

      expect(periods.map(&:period_percentage)).to eq(["20%", "40%"])
      expect(periods.map(&:start_date_str)).to eq(["02/01/2024", "01/07/2024"])
    end

    it "returns semester wrappers when the report is semester-based" do
      allow(summary).to receive(:tipo_porcentual?).and_return(false)
      allow(summary).to receive(:periodos_detalle).and_return(
        "02/01/24\t30/06/24\t180\t20%\n\n01/07/24\t31/12/24\t184\t40%"
      )

      periods = service.periodos

      expect(periods.map(&:period_percentage)).to eq(["20%", "40%"])
      expect(periods.map(&:semestre_str)).to eq([
        "Primer semestre 0,00% al 20%",
        "Primer semestre 20,01% al 40%"
      ])
    end
  end

  describe "#grouped_activities" do
    it "returns each percentage group containing its period wrappers" do
      allow(summary).to receive(:tipo_porcentual?).and_return(false)
      allow(summary).to receive(:periodos_detalle).and_return(
        "02/01/24\t30/06/24\t180\t20%\n\n01/07/24\t31/12/24\t184\t40%"
      )
      periods = service.periodos

      expect(service.grouped_activities).to eq({
        "20%" => [periods.first],
        "40%" => [periods.last]
      })
    end
  end
end
