require "rails_helper"

RSpec.describe "Courses by month", type: :feature do
  let!(:cultural_group) { ActivityGroup.create!(nombre: "Cultural") }
  let!(:sports_group) { ActivityGroup.create!(nombre: "Sports") }
  let!(:cultural_activity) { Activity.create!(nombre: "Painting", activity_group: cultural_group) }
  let!(:sports_activity) { Activity.create!(nombre: "Football", activity_group: sports_group) }
  let!(:person) { Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1") }

  def add_participation(activity, month:, year:, cargo: :estudiante)
    PersonActivity.create!(
      person: person,
      coursable: activity,
      mes: month,
      anio: year,
      cargo: cargo
    )
  end

  describe "monthly course listing" do
    it "shows participants for the requested month and year" do
      add_participation(cultural_activity, month: 3, year: 2024, cargo: :instructor)
      add_participation(cultural_activity, month: 4, year: 2024)
      add_participation(sports_activity, month: 3, year: 2023)

      visit courses_by_month_path(date: { month: 3, year: 2024 })

      expect(page).to have_content("Cultural")
      expect(page).to have_content("Painting")
      expect(page).to have_content("Jane Example")
      expect(page).to have_content("1234567890")
      expect(page).to have_content("instructor")
      expect(page).to have_content("A 1")
      expect(page).to have_content("Football sin participantes")
    end

    it "filters the displayed groups by activity_group_id" do
      add_participation(cultural_activity, month: 3, year: 2024)
      add_participation(sports_activity, month: 3, year: 2024)

      visit courses_by_month_path(
        date: { month: 3, year: 2024 },
        activity_group_id: cultural_group.id
      )

      expect(page).to have_content("Painting")
      expect(page).not_to have_content("Football")
      expect(page).to have_link("Todos")
      expect(page).to have_link("Cultural")
      expect(page).to have_link("Sports")
    end

    it "shows course headings but no participant rows when none match the selected period" do
      add_participation(cultural_activity, month: 2, year: 2024)

      visit courses_by_month_path(date: { month: 3, year: 2024 })

      expect(page).to have_content("Painting")
      expect(page).not_to have_content("Jane Example")
      expect(page).not_to have_content("Cargo")
    end

    it "provides edit and export links with the selected month and year" do
      visit courses_by_month_path(date: { month: 3, year: 2024 })

      expect(page).to have_link("Edit", href: edit_course_path(cultural_activity, date: { month: "3", year: "2024" }))
      expect(page).to have_link("Export", href: export_courses_by_month_path(activity_id: cultural_activity.id, date: { month: "3", year: "2024" }))
    end
  end
end
