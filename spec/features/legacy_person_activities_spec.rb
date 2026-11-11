require "rails_helper"

RSpec.describe "Legacy person activities", type: :feature do
  def create_activity(person:, end_date:, row_number:)
    group = ActivityGroup.find_or_create_by!(nombre: "Cultural")
    legacy_group = LegacyActivityGroup.find_or_create_by!(nombre: "Workshops", activity_group: group)
    activity = LegacyActivity.find_or_create_by!(nombre: "Weaving")
    LegacyPersonActivity.create!(
      legacy_person: person,
      legacy_activity_group: legacy_group,
      legacy_activity: activity,
      row_number: row_number,
      activity_dates: "date range",
      start_date: end_date - 30,
      end_date: end_date,
      duracion: "8 hours"
    )
  end

  it "lists legacy activities newest first" do
    person = LegacyPerson.create!(nombres: "Jane Example")
    newer = create_activity(person: person, end_date: Date.new(2024, 3, 31), row_number: 2)
    older = create_activity(person: person, end_date: Date.new(2023, 3, 31), row_number: 1)

    visit legacy_person_activities_path

    expect(page).to have_content("Legacy Person Activities")
    expect(page).to have_content("Jane Example")
    expect(page).to have_content("#{newer.id}")
    expect(page).to have_content("#{older.id}")
    expect(page.body.index(newer.id.to_s)).to be < page.body.index(older.id.to_s)
  end

  it "filters records within the requested end-date range" do
    person = LegacyPerson.create!(nombres: "Jane Example")
    person = LegacyPerson.create!(nombres: "Jane Example")
    excluded_person = LegacyPerson.create!(nombres: "Excluded Person")
    included = create_activity(person: person, end_date: Date.new(2024, 3, 31), row_number: 2)
    excluded = create_activity(person: excluded_person, end_date: Date.new(2023, 3, 31), row_number: 1)

    visit legacy_person_activities_path(date_from: "2024-01-01", date_to: "2024-12-31")

    expect(page).to have_content(included.id.to_s)
    expect(page).to have_content("Jane Example")
    expect(page).not_to have_content("#{excluded.id}")
  end
end
