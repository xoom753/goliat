require "rails_helper"

RSpec.describe "Legacy person activities", type: :feature do
  def create_activity(person:, end_date:, row_number:, group_name: "Cultural", activity_name: "Weaving", detail_name: "Attendance")
    activity_group = ActivityGroup.find_or_create_by!(nombre: group_name)
    legacy_group = LegacyActivityGroup.find_or_create_by!(nombre: "#{group_name} workshops", activity_group: activity_group)
    activity = LegacyActivity.find_or_create_by!(nombre: activity_name)
    detail = LegacyActivityDetail.find_or_create_by!(nombre: detail_name)
    LegacyPersonActivity.create!(
      legacy_person: person,
      legacy_activity_group: legacy_group,
      legacy_activity: activity,
      legacy_activity_detail: detail,
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

    expect(page).to have_content("Actividades PPL archivos")
    expect(page).to have_content("Jane Example")
    expect(page.body.index(newer.id.to_s)).to be < page.body.index(older.id.to_s)
  end

  it "filters records within the requested end-date range" do
    person = LegacyPerson.create!(nombres: "Jane Example")
    excluded_person = LegacyPerson.create!(nombres: "Excluded Person")
    included = create_activity(person: person, end_date: Date.new(2024, 3, 31), row_number: 2)
    excluded = create_activity(person: excluded_person, end_date: Date.new(2023, 3, 31), row_number: 1)

    visit legacy_person_activities_path(date_from: "2024-01-01", date_to: "2024-12-31")

    rows = all("table tbody tr").map(&:text).join(" ")
    expect(rows).to include("Jane Example", "2024-03-31")
    expect(rows).not_to include("Excluded Person", "2023-03-31")
  end

  it "filters by activity group and offers activity options for that group" do
    person = LegacyPerson.create!(nombres: "Jane Example")
    cultural = create_activity(
      person: person,
      end_date: Date.new(2024, 3, 31),
      row_number: 1,
      group_name: "Cultural",
      activity_name: "Weaving"
    )
    deportivo = create_activity(
      person: person,
      end_date: Date.new(2024, 3, 31),
      row_number: 2,
      group_name: "Deportivo",
      activity_name: "Football",
      detail_name: "Practice"
    )
    cultural_activity_group = ActivityGroup.find_by!(nombre: "Cultural")

    visit legacy_person_activities_path(activity_group_id: cultural_activity_group.id)

    rows = all("table tbody tr").map(&:text).join(" ")
    expect(rows).to include("Jane Example", "Cultural workshops", "Weaving")
    expect(rows).not_to include("Deportivo workshops", "Football")
    expect(page).to have_select("legacy_activity_id", options: [ "", "Weaving" ])
  end

  it "filters the selected group by legacy activity id" do
    person = LegacyPerson.create!(nombres: "Jane Example")
    weaving = create_activity(
      person: person,
      end_date: Date.new(2024, 3, 31),
      row_number: 1,
      group_name: "Cultural",
      activity_name: "Weaving"
    )
    painting = create_activity(
      person: person,
      end_date: Date.new(2024, 3, 31),
      row_number: 2,
      group_name: "Cultural",
      activity_name: "Painting",
      detail_name: "Artwork"
    )
    group = ActivityGroup.find_by!(nombre: "Cultural")
    selected_activity = LegacyActivity.find_by!(nombre: "Painting")

    visit legacy_person_activities_path(
      activity_group_id: group.id,
      legacy_activity_id: selected_activity.id
    )

    rows = all("table tbody tr").map(&:text).join(" ")
    expect(rows).to include("Painting", "Artwork")
    expect(rows).not_to include("Weaving", "Attendance")
  end

  it "ignores an incomplete date range and leaves all records visible" do
    first_person = LegacyPerson.create!(nombres: "Jane Example")
    second_person = LegacyPerson.create!(nombres: "Alex Rivera")
    create_activity(person: first_person, end_date: Date.new(2024, 3, 31), row_number: 1)
    create_activity(person: second_person, end_date: Date.new(2023, 3, 31), row_number: 1, activity_name: "Painting")

    visit legacy_person_activities_path(date_from: "2024-01-01")

    expect(page).to have_content("Jane Example")
    expect(page).to have_content("Alex Rivera")
  end
end
