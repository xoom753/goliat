require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer do
  describe "#activity_str" do
    it "corrects known words and preserves unknown words" do
      fixer = described_class.new(actividad_str: "Area de Pabellon y Formacion Especial")

      expect(fixer.activity_str).to eq("Área de Pabellón y Formación Especial")
    end

    it "replaces concatenated known activity wording" do
      fixer = described_class.new(actividad_str: "Actividadesdeportivas")

      expect(fixer.activity_str).to eq("Actividades deportivas")
    end
  end
end
