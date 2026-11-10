require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityRendererService::PresentActivityRenderer do
  it "exposes activity name, duration, month, and end date for a present activity" do
    activity = double(
      coursable: double(nombre: "Painting"),
      qty_h: "14 horas",
      mes: 4,
      anio: 2024,
      end_date: Date.new(2024, 4, 30)
    )
    renderer = described_class.new(current_activity: activity)

    expect(renderer.activity_nombre).to eq("Painting")
    expect(renderer.duracion_i).to eq(14)
    expect(renderer.month).to eq("4-2024")
    expect(renderer.end_date).to eq(Date.new(2024, 4, 30))
  end

  it "uses the default duration when qty_h is nil" do
    activity = double(coursable: double(nombre: "Painting"), qty_h: nil, mes: 4, anio: 2024, end_date: Date.new(2024, 4, 30))
    renderer = described_class.new(current_activity: activity)

    expect(renderer.duracion_i).to eq(30)
  end
end
