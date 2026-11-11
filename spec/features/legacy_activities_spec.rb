require "rails_helper"

RSpec.describe "Legacy activities", type: :feature do
  it "lists activities alphabetically and filters by partial name" do
    LegacyActivity.create!(nombre: "Weaving")
    LegacyActivity.create!(nombre: "Painting")
    LegacyActivity.create!(nombre: "Football")

    visit legacy_activities_path

    expect(page).to have_content("Painting")
    expect(page).to have_content("Weaving")
    expect(page).to have_content("Actividades (archivo)")

    visit legacy_activities_path(s: "Weav")

    expect(page).to have_content("Weaving")
    expect(page).not_to have_content("Painting")
    expect(page).not_to have_content("Football")
  end

  it "ignores search terms of two characters or fewer" do
    LegacyActivity.create!(nombre: "Weaving")
    LegacyActivity.create!(nombre: "Painting")

    visit legacy_activities_path(s: "We")

    expect(page).to have_content("Weaving")
    expect(page).to have_content("Painting")
  end
end
