require "rails_helper"

RSpec.describe OriginPersonHelper, type: :helper do
  around do |example|
    original_zone = Time.zone
    Time.zone = "UTC"
    example.run
  ensure
    Time.zone = original_zone
  end

  it "subtracts a year when the birthday has not occurred yet this year" do
    allow(Time.zone).to receive(:today).and_return(Date.new(2025, 5, 5))

    expect(helper.calculate_age(Date.new(2000, 5, 6))).to eq(24)
  end

  it "does not subtract a year on or after the birthday" do
    allow(Time.zone).to receive(:today).and_return(Date.new(2025, 5, 6))

    expect(helper.calculate_age(Date.new(2000, 5, 6))).to eq(25)
  end
end
