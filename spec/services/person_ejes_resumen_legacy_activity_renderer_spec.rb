require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer do
  it "appends a titleized detail for legacy course activities" do
    activity = double(
      legacy_activity: double(nombre: "Curso"),
      legacy_activity_detail: double(nombre: "primeros auxilios")
    )
    renderer = described_class.new(current_activity: activity)

    expect(renderer.activity_detail_str).to eq(" Primeros Auxilios")
  end

  it "does not append details for non-course activities" do
    activity = double(
      legacy_activity: double(nombre: "Taller"),
      legacy_activity_detail: double(nombre: "manualidades")
    )
    renderer = described_class.new(current_activity: activity)

    expect(renderer.activity_detail_str).to be_nil
  end

  it "does not append a detail when a course activity has no detail record" do
    activity = double(
      legacy_activity: double(nombre: "Curso"),
      legacy_activity_detail: nil
    )
    renderer = described_class.new(current_activity: activity)

    expect(renderer.activity_detail_str).to be_nil
  end

  it "exposes activity name, duration, month, and end date for a legacy activity" do
    activity = double(
      legacy_activity: double(nombre: "Weaving"),
      duracion: "8 horas",
      end_date: Date.new(2024, 3, 31)
    )
    renderer = described_class.new(current_activity: activity)

    expect(renderer.activity_nombre).to eq("Weaving")
    expect(renderer.duracion_i).to eq(8)
    expect(renderer.month).to eq("03-2024")
    expect(renderer.end_date).to eq(Date.new(2024, 3, 31))
  end
end
