require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer do
  describe "#activity_str" do
    it "prefers full-activity corrections before applying word-level corrections" do
      fixer = described_class.new(actividad_str: 'Prácticas O Aprendizaje De Instrumentos Musicales')

      expect(fixer.activity_str).to eq("Aprendizaje De Instrumentos Musicales")
    end

    it "preserves spacing for unknown words while correcting known words" do
      fixer = described_class.new(actividad_str: "Area Especial Desconocida")

      expect(fixer.activity_str).to eq("Área Especial Desconocida")
    end
  end
end
