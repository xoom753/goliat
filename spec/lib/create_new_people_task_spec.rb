require "rails_helper"

RSpec.describe CreateNewPeopleTask do
  describe "#call" do
    it "creates current people from matching origin people and destroys handled updates" do
      origin_person = OriginPerson.create!(
        fecha_registro: Date.new(2024, 1, 1),
        father_lastname: "CASEY",
        mother_lastname: "EXAMPLE",
        first_name: "JANE",
        dni: "1234567890"
      )
      update = PersonPabellonUpdate.create!(nombres: "CASEY  EXAMPLE JANE", pabellon: "A-1")
      unmatched = PersonPabellonUpdate.create!(nombres: "UNKNOWN PERSON", pabellon: "B-2")

      expect do
        expect { described_class.new.call }.to output(
          /Created CASEY EXAMPLE JANE.*Not found UNKNOWN PERSON.*created 1 people/m
        ).to_stdout
      end.to change(Person, :count).by(1).and change(PersonPabellonUpdate, :count).by(-1)

      person = Person.find_by!(dni: origin_person.dni)
      expect(person).to have_attributes(
        nombres: "CASEY EXAMPLE JANE",
        pabellon: "A-1",
        estado: "presente"
      )
      expect(PersonPabellonUpdate.exists?(update.id)).to be(false)
      expect(PersonPabellonUpdate.exists?(unmatched.id)).to be(true)
    end

    it "returns the number of created people" do
      OriginPerson.create!(
        fecha_registro: Date.new(2024, 1, 1),
        father_lastname: "JANE",
        first_name: "DOE",
        dni: "999"
      )
      PersonPabellonUpdate.create!(nombres: "JANE DOE", pabellon: "C-1")

      result = nil
      expect { result = described_class.new.call }.to output(/created 1 people/).to_stdout

      expect(result).to eq(1)
      expect(Person.find_by!(dni: "999").pabellon).to eq("C-1")
    end
  end
end
