require "rails_helper"

RSpec.describe LegacyActivity, type: :model do
  it "orders records alphabetically by nombre" do
    zulu = described_class.create!(nombre: "Zulu")
    alpha = described_class.create!(nombre: "Alpha")

    expect(described_class.ordered).to eq([alpha, zulu])
  end

  it "has many legacy person activities" do
    expect(described_class.reflect_on_association(:legacy_person_activities).macro).to eq(:has_many)
  end
end
