require "rails_helper"

RSpec.describe "Activity groups", type: :feature do
  it "lists treatment groups, activities, and their human names" do
    cultural = ActivityGroup.create!(nombre: "Eje Cultural")
    deportivo = ActivityGroup.create!(nombre: "Eje Deportivo")
    painting = Activity.create!(nombre: "Pintura", activity_group: cultural)
    ActivityHumanName.create!(activity: painting, nombre: "Artes Plásticas")
    Activity.create!(nombre: "Fútbol", activity_group: deportivo)

    visit activity_groups_path

    expect(page).to have_content("Ejes de tratamiento")
    expect(page).to have_content("Eje Cultural")
    expect(page).to have_content("Pintura")
    expect(page).to have_content("Artes Plásticas")
    expect(page).to have_link("Artes Plásticas", href: legacy_activities_path(s: "Artes Plásticas"))
    expect(page).to have_content("Eje Deportivo")
    expect(page).to have_content("Fútbol")
  end

  it "uses the activity name when no human name is configured" do
    group = ActivityGroup.create!(nombre: "Eje Laboral")
    Activity.create!(nombre: "Carpintería", activity_group: group)

    visit activity_groups_path

    expect(page).to have_content("Carpintería")
    expect(page).to have_link("Carpintería", href: legacy_activities_path(s: "Carpintería"))
  end

  it "renders the group table when there are no activity groups" do
    visit activity_groups_path

    expect(page).to have_content("Ejes de tratamiento")
    expect(page).to have_css("table thead")
    expect(page).not_to have_css("table tbody tr")
  end
end
