require "rails_helper"

RSpec.describe Activity, type: :model do
  it "belongs to an activity group" do
    association = described_class.reflect_on_association(:activity_group)

    expect(association.macro).to eq(:belongs_to)
  end

  it "has many person activities through its polymorphic course association" do
    association = described_class.reflect_on_association(:person_activities)

    expect(association.macro).to eq(:has_many)
    expect(association.options[:as]).to eq(:coursable)
  end
end
