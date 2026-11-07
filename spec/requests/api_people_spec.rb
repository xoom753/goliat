require "rails_helper"
require "json"

RSpec.describe "API people", type: :request do
  describe "GET /api/people" do
    it "returns matching people as text/value JSON entries" do
      match = Person.create!(nombres: "Jane Example", dni: "111")
      non_match = Person.create!(nombres: "Alex Rivera", dni: "222")

      get "/api/people", params: { q: "Example" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to eq([
        { "text" => "Jane Example - 111", "value" => match.id }
      ])
      expect(response.body).not_to include(non_match.nombres)
    end

    it "matches a partial name query" do
      person = Person.create!(nombres: "Casey Example", dni: "333")

      get "/api/people", params: { q: "Exam" }

      expect(JSON.parse(response.body)).to include(
        "text" => "Casey Example - 333",
        "value" => person.id
      )
    end

    it "returns an empty array when nothing matches" do
      Person.create!(nombres: "Alex Rivera", dni: "222")

      get "/api/people", params: { q: "Missing" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "limits the results to 20 people" do
      21.times do |index|
        Person.create!(nombres: "Shared Name #{index}", dni: "#{index}")
      end

      get "/api/people", params: { q: "Shared Name" }

      expect(JSON.parse(response.body).length).to eq(20)
    end
  end
end
