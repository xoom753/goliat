require "rails_helper"

RSpec.describe PersonPabellonUpdate, type: :model do
  it "persists a person name and pavilion update" do
    update = described_class.create!(nombres: "Casey Example", pabellon: "A-1")

    expect(described_class.find(update.id)).to have_attributes(
      nombres: "Casey Example",
      pabellon: "A-1"
    )
  end
end
