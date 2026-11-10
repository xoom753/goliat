require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityToHumanRendererService::ActivityKindIdentifier do
  describe "#identifier_str and #genre" do
    {
      "Adecentamiento del pabellón" => [:actividades, "feminine"],
      "Área laboral" => [:actividades_apoyo, "feminine"],
      "Tejido" => [:taller, "masculine"],
      "Panadería" => [:curso, "masculine"],
      "Programa teatral" => [:empty_prefix, "masculine"],
      "Copa del barrio" => [:campeonato, "masculine"],
      "Lectura" => [:curso, "masculine"]
    }.each do |activity_name, (expected_identifier, expected_genre)|
      it "classifies #{activity_name.inspect}" do
        identifier = described_class.new(kind: :cultural, activity_str: activity_name)

        expect(identifier.identifier_str).to eq(expected_identifier)
        expect(identifier.genre).to eq(expected_genre)
      end
    end

    it "defaults unmatched laboral activities to feminine actividades" do
      identifier = described_class.new(kind: :laboral, activity_str: "Apoyo administrativo")

      expect(identifier.identifier_str).to eq(:actividades)
      expect(identifier.genre).to eq("feminine")
    end
  end
end
