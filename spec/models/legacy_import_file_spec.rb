require "rails_helper"

RSpec.describe LegacyImportFile, type: :model do
  it "defines the supported import statuses" do
    expect(described_class.statuses).to include(
      "uploaded" => 0,
      "imported" => 1,
      "errored" => 2,
      "duplicate" => 3,
      "ignored" => 4,
      "file_removed" => 5
    )
  end

  it "marks a newly saved uploaded file as a duplicate when matching metadata exists" do
    existing = described_class.create!(filename: "records.xlsx", last_modified_at: "1700000000000", weight: "10")
    duplicate = described_class.create!(filename: "records.xlsx", last_modified_at: "1700000000000", weight: "10")

    expect(duplicate.reload.status).to eq("duplicate")
    expect(duplicate.duplicate_of_id).to eq(existing.id)
  end

  it "does not mark a file as duplicate when its metadata differs" do
    described_class.create!(filename: "records.xlsx", last_modified_at: "1700000000000", weight: "10")
    different = described_class.create!(filename: "records.xlsx", last_modified_at: "1700000000000", weight: "11")

    expect(different.status).to eq("uploaded")
  end

  it "formats the polymorphic parseable identifier" do
    import_file = described_class.new(parseable_id: 42, parseable_type: "LegacyFilesParser")

    expect(import_file.parseable_id_and_type).to eq("42_LegacyFilesParser")
  end

  it "converts last_modified_at milliseconds to a zoned time" do
    import_file = described_class.new(last_modified_at: "1700000000000")

    expect(import_file.last_modified_at_time).to eq(Time.zone.at(1_700_000_000))
  end

  it "sorts import files newest first by year and month" do
    older = described_class.create!(filename: "older.xlsx", year: 2023, month: 12, last_modified_at: "1", weight: "1")
    newer = described_class.create!(filename: "newer.xlsx", year: 2024, month: 1, last_modified_at: "2", weight: "1")

    expect(described_class.sorted_by_date).to eq([ newer, older ])
  end
end
