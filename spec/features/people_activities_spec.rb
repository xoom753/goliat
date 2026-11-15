require "rails_helper"

RSpec.describe "People activities", type: :feature do
  it "lists current activities with person, course, group, cargo, month, and year" do
    group = ActivityGroup.create!(nombre: "Cultural")
    activity = Activity.create!(nombre: "Painting", activity_group: group)
    person = Person.create!(nombres: "Jane Example", dni: "111", pabellon: "A-1")
    PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024, cargo: :instructor)

    visit people_activities_path(date: { month: 3 })

    expect(page).to have_content("Painting")
    expect(page).to have_content("Cultural")
    expect(page).to have_content("Jane Example")
    expect(page).to have_content("111")
    expect(page).to have_content("2024")
    expect(page).to have_content("March")
  end

  it "filters activities and options by activity group" do
    cultural = ActivityGroup.create!(nombre: "Cultural")
    deportivo = ActivityGroup.create!(nombre: "Deportivo")
    painting = Activity.create!(nombre: "Painting", activity_group: cultural)
    football = Activity.create!(nombre: "Football", activity_group: deportivo)
    person = Person.create!(nombres: "Jane Example", dni: "111")
    PersonActivity.create!(person: person, coursable: painting, mes: 3, anio: 2024)
    PersonActivity.create!(person: person, coursable: football, mes: 3, anio: 2024)

    visit people_activities_path(activity_group_id: cultural.id, date: { month: 3 })

    within "#datatables" do
      expect(page).to have_content("Painting")
      expect(page).not_to have_content("Football")
    end
    expect(page).to have_select("activity_id", options: ["Todas las actividades", "Painting"])
  end

  it "ignores an activity not belonging to the selected group" do
    cultural = ActivityGroup.create!(nombre: "Cultural")
    deportivo = ActivityGroup.create!(nombre: "Deportivo")
    painting = Activity.create!(nombre: "Painting", activity_group: cultural)
    football = Activity.create!(nombre: "Football", activity_group: deportivo)
    person = Person.create!(nombres: "Jane Example", dni: "111")
    PersonActivity.create!(person: person, coursable: painting, mes: 3, anio: 2024)
    PersonActivity.create!(person: person, coursable: football, mes: 3, anio: 2024)

    visit people_activities_path(activity_group_id: cultural.id, activity_id: football.id, date: { month: 3 })

    within "#datatables" do
      expect(page).to have_content("Painting")
      expect(page).not_to have_content("Football")
    end
  end

  it "filters by activity id" do
    group = ActivityGroup.create!(nombre: "Cultural")
    painting = Activity.create!(nombre: "Painting", activity_group: group)
    music = Activity.create!(nombre: "Music", activity_group: group)
    person = Person.create!(nombres: "Jane Example", dni: "111")
    PersonActivity.create!(person: person, coursable: painting, mes: 3, anio: 2024)
    PersonActivity.create!(person: person, coursable: music, mes: 3, anio: 2024)

    visit people_activities_path(activity_id: painting.id, date: { month: 3 })

    within "#datatables" do
      expect(page).to have_content("Painting")
      expect(page).to have_content("Jane Example")
      expect(page).not_to have_content("Music")
    end
  end
end
