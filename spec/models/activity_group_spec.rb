require "rails_helper"

RSpec.describe ActivityGroup, type: :model do
  it "has many activities" do
    expect(described_class.reflect_on_association(:activities).macro).to eq(:has_many)
  end
end
