require "rails_helper"

RSpec.describe Person, type: :model do
  it "has the supported estado values" do
    expect(described_class.estados).to include("presente" => 0, "libre" => 1, "indefinido" => 2)
  end

  it "has many person activities" do
    expect(described_class.reflect_on_association(:person_activities).macro).to eq(:has_many)
  end

  it "has the supported estado values" do
    expect(described_class.estados).to include("presente" => 0, "libre" => 1, "indefinido" => 2)
  end

  it "exposes the enum predicate and setter behavior" do
    person = described_class.new(nombres: "Casey Example", estado: :libre)

    expect(person.libre?).to be(true)
    expect { person.presente! }.to change { person.estado }.from("libre").to("presente")
  end

  describe ".from_pabellon" do
    it "returns people whose pavilion contains the requested string" do
      matching = described_class.create!(nombres: "Matching", pabellon: "CELDA_A_12")
      described_class.create!(nombres: "Other", pabellon: "CELDA_B_3")

      expect(described_class.from_pabellon("CELDA_A")).to contain_exactly(matching)
    end
  end

  describe ".from_san_jose and .not_from_san_jose" do
    it "selects San Jose pavilions and excludes them from the inverse scope" do
      san_jose = described_class.create!(nombres: "San Jose resident", pabellon: "San_Jose 1")
      other = described_class.create!(nombres: "Other resident", pabellon: "CELDA_A_12")

      expect(described_class.from_san_jose).to contain_exactly(san_jose)
      expect(described_class.not_from_san_jose).to contain_exactly(other)
    end
  end
end
