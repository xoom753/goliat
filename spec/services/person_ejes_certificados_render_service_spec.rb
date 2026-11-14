require "rails_helper"
require "csv"

RSpec.describe PersonEjesCertificadosRenderService do
  let(:person_ejes_resumen) { double("person_ejes_resumen", nombres: "Casey Example") }
  subject(:service) { described_class.new(person_ejes_resumen) }

  before { service.kinds = [ :cultural, :deportivo, :laboral ] }

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
    period = double("period", activities: activities)
    period_renderer = double("period renderer", grouped_activities: [ period ])
    report_renderer = double("report renderer", activities_by_periods_renderer_service: period_renderer)
    allow(service).to receive(:get_informe_renderer_service).with(kind).and_return(report_renderer)
  end

  describe "#to_csv" do
    it "writes the CSV header and serializes certificate columns" do
      cultural = rendered_activity(kind: :cultural, name: "Tejido", actividad_kind: "curso", months: "ENERO DE 2024", duration: "8 horas")
      stub_kind_activities(:cultural, [ cultural ])
      stub_kind_activities(:deportivo, [])
      stub_kind_activities(:laboral, [])

      rows = CSV.parse(service.to_csv, headers: true)

      expect(rows.headers).to eq([ "N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas" ])
      expect(rows.first.fields).to eq([ "1", "Casey Example", "Curso", "Tejido", "CULTURAL", "ENERO DE 2024", "8 horas" ])
    end

    it "numbers rows sequentially across treatment axes" do
      cultural = rendered_activity(kind: :cultural, name: "Painting", actividad_kind: "taller", months: "MARZO", duration: "4 horas")
      deportivo = rendered_activity(kind: :deportivo, name: "Football", actividad_kind: "curso", months: "ABRIL", duration: "6 horas")
      laboral = rendered_activity(kind: :laboral, name: "Carpentry", actividad_kind: "actividades", months: "MAYO", duration: "10 horas")
      stub_kind_activities(:cultural, [ cultural ])
      stub_kind_activities(:deportivo, [ deportivo ])
      stub_kind_activities(:laboral, [ laboral ])

      rows = CSV.parse(service.to_csv, headers: true)
      expect(rows.map { |row| row["N"] }).to eq([ "1", "2", "3" ])
      expect(rows.map { |row| row["Eje tratamiento"] }).to eq([ "CULTURAL", "DEPORTIVO", "LABORAL" ])
    end

    it "returns only headers when no certificates are found" do
      [ :cultural, :deportivo, :laboral ].each { |kind| stub_kind_activities(kind, []) }

      rows = CSV.parse(service.to_csv, headers: true)
      expect(rows.length).to eq(0)
      expect(rows.headers.last).to eq("Horas")
    end
  end

  describe "#activities" do
    it "flattens grouped activities in the configured kind order" do
      grouped = double("grouped activities", activities: [ :a, :b ])
      period_renderer = double("period renderer", grouped_activities: [ grouped ])
      report_renderer = double("report renderer", activities_by_periods_renderer_service: period_renderer)
      [ :cultural, :deportivo, :laboral ].each do |kind|
        allow(service).to receive(:get_informe_renderer_service).with(kind).and_return(report_renderer)
      end

      expect(service.activities).to eq([ :a, :b, :a, :b, :a, :b ])
    end

    it "builds a report renderer for each kind in order" do
      period_renderer = double("period renderer", grouped_activities: [])
      report_renderer = double("report renderer", activities_by_periods_renderer_service: period_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new).with(kind: :cultural, person_ejes_resumen: person_ejes_resumen).ordered.and_return(report_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new).with(kind: :deportivo, person_ejes_resumen: person_ejes_resumen).ordered.and_return(report_renderer)
      expect(PersonEjesResumen::InformeRendererService).to receive(:new).with(kind: :laboral, person_ejes_resumen: person_ejes_resumen).ordered.and_return(report_renderer)

      expect(service.activities).to eq([])
    end
  end
end
