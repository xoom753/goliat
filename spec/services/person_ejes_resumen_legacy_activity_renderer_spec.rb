require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer do
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
