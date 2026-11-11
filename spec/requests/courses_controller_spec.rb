require "rails_helper"

RSpec.describe "Courses controller", type: :request do
  let(:group) { ActivityGroup.create!(nombre: "Cultural") }
  let(:activity) { Activity.create!(nombre: "Painting", activity_group: group) }
  let(:person) { Person.create!(nombres: "Jane Example", dni: "111") }

  it "filters the edit page by requested month and year" do
    matching = PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024)
    excluded_person = Person.create!(nombres: "Alex Rivera", dni: "222")
    PersonActivity.create!(person: excluded_person, coursable: activity, mes: 4, anio: 2024)

    get edit_course_path(activity, date: { month: 3, year: 2024 })

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("March", "2024", "Jane Example", matching.id.to_s)
    expect(response.body).not_to include("Alex Rivera")
  end

  it "adds the person to the selected course and redirects preserving date filters" do
    person
    activity

    expect do
      put course_path(activity), params: { person_id: person.id, month: "3", year: "2024" }
    end.to change(PersonActivity, :count).by(1)

    expect(PersonActivity.last).to have_attributes(person: person, coursable: activity, mes: 3, anio: 2024)
    expect(response).to redirect_to(edit_course_path(activity, month: "3", year: "2024"))
  end

  it "removes a participant and redirects with the month and year" do
    person
    activity
    participant = PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024)

    expect do
      delete course_path(activity), params: { person_activity_id: participant.id, month: "3", year: "2024" }
    end.to change(PersonActivity, :count).by(-1)

    expect(response).to redirect_to(edit_course_path(activity, month: "3", year: "2024"))
  end
end
