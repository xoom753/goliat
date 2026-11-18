require "rails_helper"

RSpec.describe PersonEjesResumen::PeriodQualifierService do
  def qualifier_for(*durations)
    grouped_activities = durations.each_with_index.to_h do |duration, index|
      [ "activity-#{index}", double(duracion_i: duration) ]
    end
    described_class.new(double(group_similar_activities: grouped_activities))
  end

  it "returns zero when there are no grouped activities" do
    expect(qualifier_for.get_grade).to eq("0")
  end

  it "calculates the grade from the sum of grouped activity hours" do
    expect(qualifier_for(6, 9).get_grade).to eq("1")
  end

  it "formats a fractional grade with a decimal comma and two decimals" do
    expect(qualifier_for(7).get_grade).to eq("0,47")
  end

  it "caps grades at the maximum when hours exceed the requirement" do
    expect(qualifier_for(45).get_grade).to eq("2")
  end

  it "returns the maximum grade at the required hours" do
    expect(qualifier_for(30).get_grade).to eq("2")
  end
end
