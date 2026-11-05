require "rails_helper"

RSpec.describe Person, type: :model do
  it "has the supported estado values" do
    expect(described_class.estados).to include("presente" => 0, "libre" => 1, "indefinido" => 2)
  end

  it "has many person activities" do
    expect(described_class.reflect_on_association(:person_activities).macro).to eq(:has_many)
  end
end
