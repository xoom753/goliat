require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityToHumanRendererService do
  let(:by_months) do
    {
      Date.new(2024, 1, 31) => double(activity_nombre: "Tejido", duracion_i: 4)
    }
  end
  subject(:renderer) do
    described_class.new(
      kind: :cultural,
      activities: by_months.values,
      duracion_i: 4,
      by_months: by_months
    )
  end

  describe "#activity_str" do
    it "corrects known Spanish spelling while preserving unknown words" do
      activities = { Date.new(2024, 1, 31) => double(activity_nombre: "Area de Pabellon Especial", duracion_i: 2) }
      instance = described_class.new(kind: :cultural, activities: activities.values, duracion_i: 2, by_months: activities)

      expect(instance.activity_str).to eq("Área de Pabellón Especial")
    end
  end

  describe "#actividad_kind" do
    it "identifies a workshop activity" do
      expect(renderer.actividad_kind).to eq("taller de ")
    end

    it "defaults unmatched cultural activity names to course" do
      activities = { Date.new(2024, 1, 31) => double(activity_nombre: "Lectura", duracion_i: 1) }
      instance = described_class.new(kind: :cultural, activities: activities.values, duracion_i: 1, by_months: activities)

      expect(instance.actividad_kind).to eq("curso de ")
    end
  end

  describe "#meses_y_anios_str" do
    it "formats one month with optional uppercase" do
      expect(renderer.meses_y_anios_str).to eq("enero de 2024")
      expect(renderer.meses_y_anios_str(upcase: true)).to eq("ENERO de 2024")
    end

    it "lists multiple months in one year" do
      activities = {
        Date.new(2024, 1, 31) => double(activity_nombre: "Tejido", duracion_i: 1),
        Date.new(2024, 3, 31) => double(activity_nombre: "Tejido", duracion_i: 2)
      }
      instance = described_class.new(kind: :cultural, activities: activities.values, duracion_i: 3, by_months: activities)

      expect(instance.meses_y_anios_str).to eq("enero y marzo de 2024")
      expect(instance.meses_y_anios_str(upcase: true)).to eq("ENERO y MARZO de 2024")
    end

    it "includes the year alongside months when they span years" do
      activities = {
        Date.new(2023, 12, 31) => double(activity_nombre: "Tejido", duracion_i: 1),
        Date.new(2024, 1, 31) => double(activity_nombre: "Tejido", duracion_i: 2)
      }
      instance = described_class.new(kind: :cultural, activities: activities.values, duracion_i: 3, by_months: activities)

      expect(instance.meses_y_anios_str).to eq("diciembre de 2023 y enero de 2024")
    end
  end

  describe "#to_string" do
    it "renders the singular certificate text and total duration" do
      expect(renderer.to_string).to eq(
        "Por participar en el taller de “Tejido”, realizado durante el mes de enero de 2024 con una duración de 4 horas"
      )
    end

    it "uses plural feminine wording for actividades" do
      activities = { Date.new(2024, 2, 29) => double(activity_nombre: "Adecentamiento", duracion_i: 3) }
      instance = described_class.new(kind: :laboral, activities: activities.values, duracion_i: 3, by_months: activities)

      expect(instance.to_string).to include("Por participar en las actividades de", "realizadas durante el mes")
    end

    it "uses plural month wording when activities span multiple months" do
      activities = {
        Date.new(2024, 1, 31) => double(activity_nombre: "Lectura", duracion_i: 2),
        Date.new(2024, 2, 29) => double(activity_nombre: "Lectura", duracion_i: 5)
      }
      instance = described_class.new(kind: :cultural, activities: activities.values, duracion_i: 7, by_months: activities)

      expect(instance.to_string).to include("durante los meses de enero y febrero de 2024", "7 horas")
    end
  end
end
