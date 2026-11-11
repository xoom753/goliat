require "rails_helper"
require "csv"

RSpec.describe "Courses by month export", type: :request do
  it "exports participants for the requested activity, month, and year" do
    group = ActivityGroup.create!(nombre: "Cultural")
    activity = Activity.create!(nombre: "Painting", activity_group: group)
    included_person = Person.create!(nombres: "Jane Example", dni: "111", pabellon: "A-1")
    excluded_person = Person.create!(nombres: "Alex Rivera", dni: "222", pabellon: "B-2")
    PersonActivity.create!(person: included_person, coursable: activity, mes: 3, anio: 2024, cargo: :instructor)
    PersonActivity.create!(person: excluded_person, coursable: activity, mes: 4, anio: 2024)

    get export_courses_by_month_path(activity_id: activity.id, month: 3, year: 2024)

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("text/csv")
    expect(response.headers["Content-Disposition"]).to include("Painting-March-#{Date.today}.csv")
    rows = CSV.parse(response.body, headers: true)
    expect(rows.headers).to eq(["Nombres", "Cédula", "Cargo", "Pabellón"])
    expect(rows.map(&:fields)).to eq([["Jane Example", "111", "instructor", "A-1"]])
  end
end
