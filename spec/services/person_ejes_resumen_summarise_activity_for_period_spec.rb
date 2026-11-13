require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod do
  it "sums duration and renders a certificate for activities grouped by month" do
    activities = [
      double(activity_nombre: "Tejido", end_date: Date.new(2024, 1, 31), duracion_i: 4),
      double(activity_nombre: "Tejido", end_date: Date.new(2024, 2, 29), duracion_i: 6)
    ]
    summary = described_class.new(kind: :cultural, activities: activities)

    expect(summary.kind).to eq(:cultural)
    expect(summary.activity_str).to eq("Tejido")
    expect(summary.meses_y_anios_str).to eq("enero y febrero de 2024")
    expect(summary.duracion_str).to eq("10 horas")
    expect(summary.render_string).to include("Tejido", "enero y febrero de 2024", "10 horas")
  end

  it "uses the last activity for duplicate end dates when summing by month" do
    first = double(activity_nombre: "Lectura", end_date: Date.new(2024, 1, 31), duracion_i: 2)
    last = double(activity_nombre: "Lectura", end_date: Date.new(2024, 1, 31), duracion_i: 7)
    summary = described_class.new(kind: :cultural, activities: [ first, last ])

    expect(summary.duracion_str).to eq("7 horas")
  end
end
