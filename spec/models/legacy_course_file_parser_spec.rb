require "rails_helper"

RSpec.describe LegacyCourseFileParser, type: :model do
  it "combines its id and class name" do
    parser = described_class.create!(parser_name: "Courses")

    expect(parser.id_and_type).to eq("#{parser.id}_LegacyCourseFileParser")
  end
end
