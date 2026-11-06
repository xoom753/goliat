require "rails_helper"

RSpec.describe LegacyFilesParser, type: :model do
  it "#id_and_type combines its id and class name" do
    parser = described_class.create!

    expect(parser.id_and_type).to eq("#{parser.id}_LegacyFilesParser")
  end
end
