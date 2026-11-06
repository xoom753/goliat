require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer do
  let(:renderer_class) do
    Class.new(described_class) do
      def initialize(name:, date:, duration:, kind:)
        @name = name
        @activity_end_date = date
        @duracion = duration
        @kind = kind
      end

      def actividad_str
        @name
      end
    end
  end

  it "formats month capitalization and appends hours only when needed" do
    renderer = renderer_class.new(name: "Curso", date: Date.new(2025, 1, 31), duration: "4", kind: :cultural)

    expect(renderer.get_months_and_year).to eq("enero de 2025")
    expect(renderer.get_months_and_year(upcase: true)).to eq("ENERO de 2025")
    expect(renderer.duracion_str).to eq("4 horas")
  end

  it "keeps durations that already include horas" do
    renderer = renderer_class.new(name: "Curso", date: Date.new(2025, 1, 31), duration: "4 horas", kind: :cultural)

    expect(renderer.duracion_str).to eq("4 horas")
  end

  it "uses the default course kind for unmatched cultural activity names" do
    renderer = renderer_class.new(name: "Lectura", date: Date.new(2025, 1, 31), duration: "4", kind: :cultural)

    expect(renderer.activity_kind_str).to eq("curso de")
    expect(renderer.cert_string).to include("curso de", "Lectura")
  end
end
