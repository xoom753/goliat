require "rails_helper"

RSpec.describe LegacyActivityDetail, type: :model do
  it "persists its nombre" do
    detail = described_class.create!(nombre: "Attendance")

    expect(described_class.find(detail.id).nombre).to eq("Attendance")
  end

  it "orders details alphabetically by nombre" do
    zulu = described_class.create!(nombre: "Zulu")
    alpha = described_class.create!(nombre: "Alpha")
    middle = described_class.create!(nombre: "Middle")

    expect(described_class.ordered).to eq([ alpha, middle, zulu ])
  end
end
