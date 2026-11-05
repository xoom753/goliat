require "rails_helper"

RSpec.describe OriginPersonDemographic, type: :model do
  it "belongs to an origin person" do
    expect(described_class.reflect_on_association(:origin_person).macro).to eq(:belongs_to)
  end

  it "is invalid without an origin person" do
    expect(described_class.new).not_to be_valid
  end
end
