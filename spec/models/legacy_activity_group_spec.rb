require "rails_helper"

RSpec.describe LegacyActivityGroup, type: :model do
  it "allows an activity group to be absent" do
    expect(described_class.new(activity_group: nil)).to be_valid
  end

  it "orders records alphabetically by nombre" do
    zulu = described_class.create!(nombre: "Zulu")
    alpha = described_class.create!(nombre: "Alpha")

    expect(described_class.ordered).to eq([alpha, zulu])
  end

  it "belongs to an optional activity group" do
    association = described_class.reflect_on_association(:activity_group)

    expect(association.macro).to eq(:belongs_to)
    expect(association.options[:optional]).to be(true)
  end
end
