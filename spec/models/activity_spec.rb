require "rails_helper"

RSpec.describe Activity, type: :model do
  let(:activity_group) { ActivityGroup.create!(nombre: "Eje Cultural") }
  let(:activity) { described_class.create!(nombre: "Tejido", activity_group: activity_group) }

  it "belongs to an activity group" do
    association = described_class.reflect_on_association(:activity_group)

    expect(association.macro).to eq(:belongs_to)
    expect(activity.activity_group).to eq(activity_group)
  end

  it "has one optional human name" do
    association = described_class.reflect_on_association(:activity_human_name)

    expect(association.macro).to eq(:has_one)
    expect(activity.activity_human_name).to be_nil
  end

  it "has many person activities through its polymorphic course association" do
    association = described_class.reflect_on_association(:person_activities)

    expect(association.macro).to eq(:has_many)
    expect(association.options[:as]).to eq(:coursable)
  end

  describe ".order_by_name" do
    it "sorts activities alphabetically by name" do
      zulu = described_class.create!(nombre: "Zulu", activity_group: activity_group)
      alpha = described_class.create!(nombre: "Alpha", activity_group: activity_group)
      middle = described_class.create!(nombre: "Middle", activity_group: activity_group)

      expect(described_class.order_by_name).to eq([ alpha, middle, zulu ])
    end
  end

  describe "#human_name" do
    it "returns the activity name when there is no human name" do
      expect(activity.human_name).to eq("Tejido")
    end

    it "returns its associated human name when present" do
      ActivityHumanName.create!(activity: activity, nombre: "Artesanía")

      expect(activity.reload.human_name).to eq("Artesanía")
    end
  end
end
