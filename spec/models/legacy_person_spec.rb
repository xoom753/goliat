require "rails_helper"

RSpec.describe LegacyPerson, type: :model do
  it "has many legacy person activities" do
    expect(described_class.reflect_on_association(:legacy_person_activities).macro).to eq(:has_many)
  end
end
