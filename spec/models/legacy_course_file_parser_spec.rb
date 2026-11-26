require "rails_helper"

RSpec.describe LegacyCourseFileParser, type: :model do
  it "#id_and_type combines its id and class name" do
    parser = described_class.create!(parser_name: "Courses")

    expect(parser.id_and_type).to eq("#{parser.id}_LegacyCourseFileParser")
  end

  it "splits ignored row names into lowercase lines and memoizes the result" do
    parser = described_class.create!(parser_name: "Courses", ignore_specific_rows: "TOTAL\n  SUBTOTAL  ")

    expect(parser.ignore_specific_rows_array).to eq([ "total", "  subtotal  " ])
    expect(parser.ignore_specific_rows_array).to equal(parser.ignore_specific_rows_array)
  end
end
