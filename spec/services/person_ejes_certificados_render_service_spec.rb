require "rails_helper"
require "csv"

RSpec.describe PersonEjesCertificadosRenderService do
  let(:person_ejes_resumen) { double("person_ejes_resumen", nombres: "Casey Example") }
  subject(:service) { described_class.new(person_ejes_resumen) }

  before { service.kinds = [:cultural, :deportivo, :laboral] }

  before do
    service.kinds = [:cultural, :deportivo, :laboral]
  end

  def rendered_activity(kind:, name:, actividad_kind:, months:, duration:)
    double(
      "#{kind}_#{name}",
      actividad_kind: actividad_kind,
      activity_str: name,
      kind: kind,
      meses_y_anios_str: months,
      duracion_str: duration
    )
  end

  def stub_kind_activities(kind, activities)
    grouped_activities = double("grouped activities", activities: activities)
    period_renderer = double("period renderer", grouped_activities: [grouped_activities])
    informe_renderer = double("report renderer")
    allow(informe_renderer).to receive(:send)
      .with(:activities_by_periods_renderer_service)
      .and_return(period_renderer)
    allow(service).to receive(:get_informe_renderer_service)
      .with(kind)
      .and_return(informe_renderer)
  end

  describe "#to_csv" do
    it "writes the header and serializes certificate activity columns" do
      activity = rendered_activity(
        kind: :cultural,
        name: "Tejido",
        actividad_kind: "curso",
        months: "ENERO DE 2024",
        duration: "8 horas"
      )
      stub_kind_activities(:cultural, [activity])
      stub_kind_activities(:deportivo, [])
      stub_kind_activities(:laboral, [])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.headers).to eq([
        "N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"
      ])
      expect(rows.length).to eq(1)
      expect(rows.first.fields).to eq([
        "1", "Casey Example", "Curso", "Tejido", "CULTURAL", "ENERO DE 2024", "8 horas"
      ])
    end

    it "numbers rows sequentially across treatment axes in axis order" do
      cultural = rendered_activity(
        kind: :cultural,
        name: "Painting",
        actividad_kind: "taller",
        months: "MARZO DE 2024",
        duration: "4 horas"
      )
      deportivo = rendered_activity(
        kind: :deportivo,
        name: "Football",
        actividad_kind: "actividad",
        months: "ABRIL DE 2024",
        duration: "6 horas"
      )
      laboral = rendered_activity(
        kind: :laboral,
        name: "Carpentry",
        actividad_kind: "actividad",
        months: "MAYO DE 2024",
        duration: "10 horas"
      )
      stub_kind_activities(:cultural, [cultural])
      stub_kind_activities(:deportivo, [deportivo])
      stub_kind_activities(:laboral, [laboral])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.map { |row| row["N"] }).to eq(["1", "2", "3"])
      expect(rows.map { |row| row["Eje tratamiento"] }).to eq(["CULTURAL", "DEPORTIVO", "LABORAL"])
      expect(rows.map { |row| row["Nombre curso"] }).to eq(["Painting", "Football", "Carpentry"])
    end

    it "returns a header-only CSV when there are no activities" do
      period_renderer = double("period renderer", grouped_activities: [])
      report_renderer = double("report renderer")
      allow(report_renderer).to receive(:send)
        .with(:activities_by_periods_renderer_service)
        .and_return(period_renderer)
      allow(PersonEjesResumen::InformeRendererService).to receive(:new).and_return(report_renderer)

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.headers).to eq([
        "N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"
      ])
      expect(rows.length).to eq(0)
    end
  end

  describe "#activities" do
    it "collects the flattened activities in cultural, deportivo, laboral order" do
      cultural_one = rendered_activity(kind: :cultural, name: "A", actividad_kind: "curso", months: "ENERO", duration: "1")
      cultural_two = rendered_activity(kind: :cultural, name: "B", actividad_kind: "curso", months: "FEBRERO", duration: "2")
      deportivo = rendered_activity(kind: :deportivo, name: "C", actividad_kind: "curso", months: "MARZO", duration: "3")
      laboral = rendered_activity(kind: :laboral, name: "D", actividad_kind: "curso", months: "ABRIL", duration: "4")
      stub_kind_activities(:cultural, [cultural_one, cultural_two])
      stub_kind_activities(:deportivo, [deportivo])
      stub_kind_activities(:laboral, [laboral])

      expect(service.send(:activities)).to eq([cultural_one, cultural_two, deportivo, laboral])
    end

    it "requests one report renderer for each treatment axis in order" do
      period_renderer = double("period renderer", grouped_activities: [])
      report_renderer = double("report renderer")
      allow(report_renderer).to receive(:send)
        .with(:activities_by_periods_renderer_service)
        .and_return(period_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new)
        .with(kind: :cultural, person_ejes_resumen: person_ejes_resumen).ordered
        .and_return(report_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new)
        .with(kind: :deportivo, person_ejes_resumen: person_ejes_resumen).ordered
        .and_return(report_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new)
        .with(kind: :laboral, person_ejes_resumen: person_ejes_resumen).ordered
        .and_return(report_renderer)

      expect(service.send(:activities)).to eq([])
    end
  end
end
