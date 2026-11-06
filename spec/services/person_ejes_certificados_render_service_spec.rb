require "rails_helper"
require "csv"

RSpec.describe PersonEjesCertificadosRenderService do
  let(:first_period) { { start_date: "01/01/2024", end_date: "30/06/2024" } }
  let(:person_ejes_renderer) { double(nombres: "Casey Example") }
  let(:informe_renderer_service) do
    double(
      person_ejes_renderer: person_ejes_renderer,
      tipo_porcentual?: true,
      get_first_period: first_period
    )
  end
  let(:cultural_activity) do
    double(
      activity_kind_str: "curso",
      actividad_str: "Tejido",
      kind: :cultural,
      get_months_and_year: "ENERO DE 2024",
      duracion_str: "8 horas"
    )
  end
  subject(:service) { described_class.new(informe_renderer_service) }

  describe "#to_csv" do
    it "exports the headers and activity details" do
      allow(service).to receive(:activities).and_return([cultural_activity])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.headers).to eq(["N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"])
      expect(rows.first.fields).to eq(["1", "Casey Example", "Curso", "Tejido", "CULTURAL", "ENERO DE 2024", "8 horas"])
    end

    it "numbers multiple activity rows sequentially" do
      second_activity = double(
        activity_kind_str: "taller",
        actividad_str: "Cerámica",
        kind: :deportivo,
        get_months_and_year: "FEBRERO DE 2024",
        duracion_str: "4 horas"
      )
      allow(service).to receive(:activities).and_return([cultural_activity, second_activity])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.map { |row| row["N"] }).to eq(["1", "2"])
      expect(rows.map { |row| row["Eje tratamiento"] }).to eq(["CULTURAL", "DEPORTIVO"])
    end

    it "emits only headers when no activities qualify" do
      allow(service).to receive(:activities).and_return([])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.length).to eq(0)
      expect(rows.headers.last).to eq("Horas")
    end
  end

  describe "activity selection" do
    it "uses the first period once for each axis in percentage mode" do
      allow(informe_renderer_service).to receive(:get_activities_within_period).and_return([cultural_activity], [], [])
      expect(informe_renderer_service).to receive(:kind=).with(:cultural).ordered
      expect(informe_renderer_service).to receive(:kind=).with(:deportivo).ordered
      expect(informe_renderer_service).to receive(:kind=).with(:laboral).ordered
      expect(informe_renderer_service).to receive(:period=).with(first_period).exactly(3).times

      expect(service.send(:activities)).to eq([cultural_activity])
    end

    it "collects activities from every semester period for each axis in non-percentage mode" do
      periods = {
        "Primer semestre" => [
          { start_date: "01/01/2024", end_date: "30/06/2024" },
          { start_date: "01/07/2024", end_date: "31/12/2024" }
        ]
      }
      allow(informe_renderer_service).to receive(:tipo_porcentual?).and_return(false)
      allow(informe_renderer_service).to receive(:semestres_detail_hash).and_return(periods)
      allow(informe_renderer_service).to receive(:get_activities_within_period).and_return(
        [cultural_activity], [cultural_activity], [], [], [], []
      )
      expect(informe_renderer_service).to receive(:kind=).with(:cultural)
      expect(informe_renderer_service).to receive(:kind=).with(:deportivo)
      expect(informe_renderer_service).to receive(:kind=).with(:laboral)
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.first).ordered
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.last).ordered
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.first).ordered
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.last).ordered
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.first).ordered
      expect(informe_renderer_service).to receive(:period=).with(periods.values.first.last).ordered

      expect(service.send(:activities)).to eq([cultural_activity, cultural_activity])
    end
  end

  context "when tipo_porcentual? is false" do
    let(:semester_periods) do
      {
        "Primer semestre" => [
          { start_date: "01/01/2024", end_date: "30/06/2024" },
          { start_date: "01/07/2024", end_date: "31/12/2024" }
        ],
        "Segundo semestre" => [
          { start_date: "01/01/2025", end_date: "30/06/2025" }
        ]
      }
    end

    before do
      allow(informe_renderer_service).to receive(:tipo_porcentual?).and_return(false)
      allow(informe_renderer_service).to receive(:semestres_detail_hash).and_return(semester_periods)

      expect(informe_renderer_service).to receive(:kind=).with(:cultural)

      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][0]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][1]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Segundo semestre"][0]).ordered

      expect(informe_renderer_service).to receive(:kind=).with(:deportivo)

      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][0]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][1]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Segundo semestre"][0]).ordered

      expect(informe_renderer_service).to receive(:kind=).with(:laboral)

      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][0]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Primer semestre"][1]).ordered
      expect(informe_renderer_service).to receive(:period=).with(semester_periods["Segundo semestre"][0]).ordered
    end

    it "sets the selected kind and period for every semester period" do
      expect(informe_renderer_service).to receive(:get_activities_within_period).exactly(9).times.and_return([cultural_activity], [], [], [], [], [], [], [], [])

      expect(service.send(:activities)).to eq([cultural_activity])
    end

    it "returns no activities when every semester lookup is empty" do
      allow(informe_renderer_service).to receive(:get_activities_within_period).and_return([])

      expect(service.send(:activities)).to eq([])
    end
  end
end
