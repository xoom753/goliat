require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesGroupService::GroupSimilarActivities do
  it "creates one summarizer per activity name and groups matching names" do
    first = double(
      "first",
      activity_nombre: "Weaving",
      end_date: "end_date"
    )
    repeated = double(
      "repeated",
      activity_nombre: "Weaving",
      end_date: "end_date",
      duracion_i: 4
    )
    another = double(
      "another",
      activity_nombre: "Painting",
      end_date: "end_date",
      duracion_i: 4
    )
    grouped = described_class.new(kind: :cultural, activities: [ first, repeated, another ]).grouped

    expect(grouped.keys).to contain_exactly("Weaving", "Painting")
    expect(grouped["Weaving"]).to be_a(PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod)
    expect(grouped["Painting"]).to be_a(PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod)
  end

  it "returns an empty hash when there are no activities" do
    expect(described_class.new(kind: :cultural, activities: []).grouped).to eq({})
  end
end
