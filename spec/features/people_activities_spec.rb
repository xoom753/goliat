require "rails_helper"

RSpec.describe "People activities", type: :feature do
  it "lists current activities with person, course, group, cargo, month, and year" do
    group = ActivityGroup.create!(nombre: "Cultural")
    activity = Activity.create!(nombre: "Painting", activity_group: group)
    person = Person.create!(nombres: "Jane Example", dni: "111", pabellon: "A-1")
    PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024, cargo: :instructor)

    visit people_activities_path

    expect(page).to have_content("Painting")
    expect(page).to have_content("Cultural")
    expect(page).to have_content("Jane Example")
    expect(page).to have_content("111")
    expect(page).to have_content("2024")
    expect(page).to have_content("March")
  end

  it "filters by activity id" do
    group = ActivityGroup.create!(nombre: "Cultural")
    painting = Activity.create!(nombre: "Painting", activity_group: group)
    music = Activity.create!(nombre: "Music", activity_group: group)
    person = Person.create!(nombres: "Jane Example", dni: "111")
    PersonActivity.create!(person: person, coursable: painting, mes: 3, anio: 2024)
    PersonActivity.create!(person: person, coursable: music, mes: 3, anio: 2024)

    visit people_activities_path(activity_id: painting.id)

      expect(page).to have_content("Painting")
      expect(page).to have_content("Jane Example")
      expect(page).not_to have_content("Music")
  end
end
