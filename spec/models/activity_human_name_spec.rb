require "rails_helper"

RSpec.describe ActivityHumanName, type: :model do
  let(:activity_group) { ActivityGroup.create!(nombre: "Eje Cultural") }
  let(:activity) { Activity.create!(nombre: "Tejido", activity_group: activity_group) }

  it "belongs to an activity" do
    association = described_class.reflect_on_association(:activity)

    expect(association.macro).to eq(:belongs_to)
  end

  it "is valid with a name and associated activity" do
    human_name = described_class.new(nombre: "Artesanía", activity: activity)

    expect(human_name).to be_valid
  end

  it "requires a name" do
    human_name = described_class.new(activity: activity)

    expect(human_name).not_to be_valid
    expect(human_name.errors[:nombre]).to include("can't be blank")
  end

  it "persists its name and activity association" do
    human_name = described_class.create!(nombre: "Artesanía", activity: activity)

    expect(human_name.reload.nombre).to eq("Artesanía")
    expect(human_name.activity).to eq(activity)
  end
end
