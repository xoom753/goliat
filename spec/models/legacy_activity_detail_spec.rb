require "rails_helper"

RSpec.describe LegacyActivityDetail, type: :model do
  it "persists its nombre" do
    detail = described_class.create!(nombre: "Attendance")

    expect(described_class.find(detail.id).nombre).to eq("Attendance")
  end
end
