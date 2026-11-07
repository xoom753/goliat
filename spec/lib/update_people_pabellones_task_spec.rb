require "rails_helper"

RSpec.describe UpdatePeoplePabellonesTask do
  describe "#call" do
    it "marks all people undefined, updates matching names, and removes handled updates" do
      matching_person = Person.create!(nombres: "CASEY EXAMPLE", dni: "123", estado: :libre)
      Person.create!(nombres: "OTHER PERSON", dni: "456", estado: :presente)
      update = PersonPabellonUpdate.create!(nombres: " CASEY EXAMPLE ", pabellon: "A-1")
      unmatched = PersonPabellonUpdate.create!(nombres: "MISSING PERSON", pabellon: "B-2")
      allow(Person).to receive(:update_all).with(estado: :indefinido).and_call_original

      expect do
        expect { described_class.new.call }.to output(
          /WARN setting all people as :indefinido.*Not found MISSING PERSON - B-2.*updated correctly 1 people/m
        ).to_stdout
      end.to change(PersonPabellonUpdate, :count).by(-1)

      expect(matching_person.reload).to have_attributes(estado: "presente", pabellon: "A-1")
      expect(Person.find_by!(nombres: "OTHER PERSON").estado).to eq("indefinido")
      expect(PersonPabellonUpdate.exists?(unmatched.id)).to be(true)
      expect(PersonPabellonUpdate.exists?(update.id)).to be(false)
    end

    it "returns the number of matched pavilion updates" do
      person = Person.create!(nombres: "CASEY EXAMPLE", dni: "123")
      PersonPabellonUpdate.create!(nombres: "CASEY EXAMPLE", pabellon: "A-1")
      allow(Person).to receive(:update_all).and_call_original
      allow(PersonPabellonUpdate).to receive(:find_each).and_yield(PersonPabellonUpdate.last)

      result = nil
      expect { result = described_class.new.call }.to output(/updated correctly 1 people/).to_stdout

      expect(result).to eq(1)
      expect(person.reload.pabellon).to eq("A-1")
    end
  end
end
