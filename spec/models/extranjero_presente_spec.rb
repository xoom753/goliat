require "rails_helper"

RSpec.describe ExtranjeroPresente, type: :model do
  it "normalizes a names string by trimming and titleizing each word" do
    extranjero = described_class.new
    extranjero.nombres_str = "  MARIA   DEL CARMEN  "

    expect(extranjero.nombres).to eq("Maria Del Carmen")
  end

  it "finds the matching present person by uppercase name and memoizes the result" do
    person = Person.create!(nombres: "MARIA DEL CARMEN", dni: "111")
    extranjero = described_class.create!(nombres: "Maria Del Carmen", pasaporte: "P-1")

    expect(extranjero.person).to have_attributes(id: person.id, nombres: person.nombres)
    first_lookup = extranjero.person
    expect(extranjero.person).to equal(first_lookup)
  end

  it "returns no present person when no name matches" do
    extranjero = described_class.create!(nombres: "Unknown Person", pasaporte: "P-2")

    expect(extranjero.person).to be_nil
  end

  it "finds matching legacy people and returns their IDs" do
    first = LegacyPerson.create!(nombres: "MARIA DEL CARMEN")
    second = LegacyPerson.create!(nombres: "MARIA DEL CARMEN")
    extranjero = described_class.create!(nombres: "Maria Del Carmen", pasaporte: "P-3")

    expect(extranjero.legacy_people).to contain_exactly(first, second)
    expect(extranjero.legacy_people_ids).to contain_exactly(first.id, second.id)
  end
end
