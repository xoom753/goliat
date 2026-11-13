require "rails_helper"

RSpec.describe "Import people", type: :request do
  describe "POST /import_people" do
    it "creates people from tab-separated pavilion, name, and DNI values" do
      expect do
        post import_people_path, params: {
          people: "A-1\tJane Doe\t111\nB-2\tAlex Rivera\t222"
        }
      end.to change(Person, :count).by(2)

      expect(response).to redirect_to(action: :new)
      expect(flash[:notice]).to eq("Imported 2 people!")
      expect(Person.order(:dni).map { |person| [ person.pabellon, person.nombres, person.dni ] }).to eq([
        [ "A-1", "Jane Doe", "111" ],
        [ "B-2", "Alex Rivera", "222" ]
      ])
    end
  end
end
