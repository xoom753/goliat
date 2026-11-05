require "rails_helper"

RSpec.describe LegacyPersonActivity, type: :model do
  describe ".parse_date_str" do
    it "parses day/month/year dates" do
      expect(described_class.parse_date_str("02/06/2022")).to eq(Date.new(2022, 6, 2))
    end

    it "rejects invalid dates" do
      expect { described_class.parse_date_str("31/02/2022") }.to raise_error(Date::Error)
    end
  end

  it "creates referenced legacy records from supplied names before saving" do
    record = described_class.create!(
      nombres_str: "Casey Example",
      activity_str: "Workshop",
      activity_group_str: "Education",
      activity_detail_str: "Attendance"
    )

    expect(record.legacy_person.nombres).to eq("Casey Example")
    expect(record.legacy_activity.nombre).to eq("Workshop")
    expect(record.legacy_activity_group.nombre).to eq("Education")
    expect(record.legacy_activity_detail.nombre).to eq("Attendance")
  end

  it "orders activities oldest first by end date" do
    recent = described_class.create!(end_date: Date.new(2024, 2, 1))
    earlier = described_class.create!(end_date: Date.new(2023, 2, 1))

    expect(described_class.oldest_first).to eq([earlier, recent])
  end
end
