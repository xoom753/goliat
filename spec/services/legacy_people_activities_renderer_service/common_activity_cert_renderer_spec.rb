require "rails_helper"

RSpec.describe LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer do
  let(:renderer_class) do
    Class.new(described_class) do
      def initialize(name:, date: Date.new(2025, 1, 31), duration: "4", kind: :cultural)
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

  def renderer(name:, duration: "4", kind: :cultural, date: Date.new(2025, 1, 31))
    renderer_class.new(name: name, date: date, duration: duration, kind: kind)
  end

  describe "#get_months_and_year" do
    it "formats the activity month and year, optionally uppercasing the month" do
      instance = renderer(name: "Lectura")

      expect(instance.get_months_and_year).to eq("enero de 2025")
      expect(instance.get_months_and_year(upcase: true)).to eq("ENERO de 2025")
    end

    it "formats each month name with the activity year" do
      expected_months = described_class::MESES
      expected_months.each_with_index do |month, index|
        instance = renderer(name: "Lectura", date: Date.new(2024, index + 1, 1))

        expect(instance.get_months_and_year).to eq("#{month} de 2024")
      end
    end
  end

  describe "#duracion_str" do
    it "appends horas when the duration does not already include it" do
      expect(renderer(name: "Lectura", duration: "4").duracion_str).to eq("4 horas")
    end

    it "does not append a second horas suffix" do
      expect(renderer(name: "Lectura", duration: "4 horas").duracion_str).to eq("4 horas")
    end
  end

  describe "#activity_kind_str" do
    {
      "programa teatral" => "",
      "concurso de pintura" => "",
      "agasajo institucional" => "",
      "taller artesanal" => "",
      "coro" => "",
      "cine foro" => "",
      "adecentamiento del pabellón" => "actividades de",
      "manualidades" => "taller de",
      "artesanías" => "taller de",
      "panificación" => "taller de",
      "tejido" => "taller de",
      "panadería" => "curso de",
      "cuidado del cabello" => "curso de",
      "origami" => "curso de",
      "obra teatral" => "programa",
      "campeonato copa relámpago" => "campeonato"
    }.each do |activity_name, expected_kind|
      it "classifies #{activity_name.inspect} as #{expected_kind.inspect}" do
        expect(renderer(name: activity_name).activity_kind_str).to eq(expected_kind)
      end
    end

    it "uses the first matching category when more than one pattern matches" do
      expect(renderer(name: "Programa teatral de adecentamiento").activity_kind_str).to eq("")
      expect(renderer(name: "Taller de panadería").activity_kind_str).to eq("")
    end

    it "defaults unmatched cultural activities to a course" do
      expect(renderer(name: "Lectura").activity_kind_str).to eq("curso de")
    end

    it "defaults unmatched labor activities to actividades" do
      expect(renderer(name: "Apoyo administrativo", kind: :laboral).activity_kind_str).to eq("actividades de")
    end
  end

  describe "#cert_string" do
    {
      "Lectura" => ["Por participar en el curso de", "Lectura"],
      "Programa teatral" => ["Por participar en el “", "Programa teatral"],
      "Tejido" => ["Por participar en el taller de", "Tejido"],
      "Panadería" => ["Por participar en el curso de", "Panadería"],
      "Adecentamiento del pabellón" => ["Por participar en las actividades de", "Adecentamiento del pabellón"],
      "Campeonato copa relámpago" => ["Por participar en el campeonato", "Campeonato copa relámpago"]
    }.each do |activity_name, fragments|
      it "renders certificate text for #{activity_name.inspect}" do
        expect(renderer(name: activity_name).cert_string).to include(*fragments, "enero de 2025", "4 horas")
      end
    end

    it "uses the no-prefix certificate wording for empty-prefix activities" do
      expect(renderer(name: "Concurso de pintura").cert_string).to eq(
        "Por participar en el “Concurso de pintura”, realizado durante el mes de enero de 2025 con una duración de 4 horas"
      )
    end

    it "uses plural wording for adecentamiento activities" do
      expect(renderer(name: "Adecentamiento del pabellón").cert_string).to include(
        "Por participar en las actividades de",
        "realizadas durante el mes de enero de 2025"
      )
    end
  end
end
