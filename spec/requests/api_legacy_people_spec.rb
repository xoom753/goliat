require "rails_helper"
require "json"

RSpec.describe "API legacy people", type: :request do
  describe "GET /api/legacy_people" do
    it "returns matching legacy people using the API text/value shape" do
      match = LegacyPerson.create!(nombres: "CASEY EXAMPLE", dni: "111")
      LegacyPerson.create!(nombres: "ALEX RIVERA", dni: "222")

      get "/api/legacy_people", params: { q: "CASEY" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to eq([
        { "text" => "CASEY EXAMPLE - (uuid #{match.id})", "value" => match.id }
      ])
    end

    it "returns an empty list when nothing matches" do
      get "/api/legacy_people", params: { q: "MISSING" }

      expect(JSON.parse(response.body)).to eq([])
    end

    it "limits results to twenty records" do
      21.times { |index| LegacyPerson.create!(nombres: "SHARED #{index}", dni: "#{index}") }

      get "/api/legacy_people", params: { q: "SHARED" }

      expect(JSON.parse(response.body).length).to eq(20)
    end
  end
end
