require "rails_helper"

RSpec.describe "Person pavilion updates", type: :request do
  describe "GET /person_pabellon_updates/new" do
    it "renders the bulk update form" do
      get new_person_pabellon_update_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Update people and their cells", "updates")
    end
  end

  describe "POST /person_pabellon_updates" do
    it "creates one update per tab-separated input row" do
      expect do
        post person_pabellon_updates_path, params: {
          updates: "Jane Example\tA-1\nAlex Rivera\tB-2"
        }
      end.to change(PersonPabellonUpdate, :count).by(2)

      expect(PersonPabellonUpdate.order(:id).map { |row| [row.nombres, row.pabellon] }).to eq([
        ["Jane Example", "A-1"],
        ["Alex Rivera", "B-2"]
      ])
      expect(response).to redirect_to(new_person_pabellon_update_path(notice: "Imported 2 updates!"))
    end
  end
end
