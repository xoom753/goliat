require "rails_helper"

RSpec.describe "Legacy people", type: :feature do
  let!(:activity_group) { ActivityGroup.create!(nombre: "Cultural") }
  let!(:legacy_group) do
    LegacyActivityGroup.create!(nombre: "Workshops", activity_group: activity_group)
  end
  let!(:activity) { LegacyActivity.create!(nombre: "Weaving") }
  let!(:detail) { LegacyActivityDetail.create!(nombre: "Attendance") }

  def create_legacy_person(name:, dni:)
    LegacyPerson.create!(nombres: name, dni: dni)
  end

  def add_activity(person, end_date: Date.new(2024, 3, 31))
    LegacyPersonActivity.create!(
      legacy_person: person,
      legacy_activity: activity,
      legacy_activity_group: legacy_group,
      legacy_activity_detail: detail,
      start_date: end_date - 30,
      end_date: end_date,
      duracion: "12 horas"
    )
  end

  describe "GET /legacy_people" do
    it "lists people with their activity details" do
      person = create_legacy_person(name: "Jane Example", dni: "111")
      add_activity(person)

      visit legacy_people_path

      expect(page).to have_content("Legacy People")
      expect(page).to have_content("Jane Example")
      expect(page).to have_content("111")
      expect(page).to have_content("Weaving")
      expect(page).to have_content("Workshops")
      expect(page).to have_content("Attendance")
      expect(page).to have_content("2024-03-31")
      expect(page).to have_content("12 horas")
      expect(page).to have_link("new ejes resumen", href: new_person_ejes_resumen_path(legacy_person_id: person.id))
    end

    it "filters people by a partial name query" do
      create_legacy_person(name: "Jane Example", dni: "111")
      create_legacy_person(name: "Alex Rivera", dni: "222")

      visit legacy_people_path(q: "Jane")

      expect(page).to have_content("Jane Example")
      expect(page).not_to have_content("Alex Rivera")
    end

    it "shows an empty table when no people match" do
      create_legacy_person(name: "Jane Example", dni: "111")

      visit legacy_people_path(q: "Missing")

      expect(page).to have_content("Legacy People")
      expect(page).not_to have_content("Jane Example")
    end
  end

  describe "GET /legacy_people/:id" do
    it "shows all activities for the selected person" do
      selected = create_legacy_person(name: "Jane Example", dni: "111")
      other = create_legacy_person(name: "Alex Rivera", dni: "222")
      add_activity(selected)
      add_activity(other, end_date: Date.new(2023, 2, 28))

      visit legacy_person_path(selected)

      expect(page).to have_content("Jane Example")
      expect(page).to have_content("Weaving")
      expect(page).not_to have_content("Alex Rivera")
    end
  end

  describe "GET /legacy_people/view_several" do
    it "shows only the requested people and their activity histories" do
      first = create_legacy_person(name: "Jane Example", dni: "111")
      second = create_legacy_person(name: "Alex Rivera", dni: "222")
      excluded = create_legacy_person(name: "Sam Taylor", dni: "333")
      add_activity(first)
      add_activity(second, end_date: Date.new(2023, 2, 28))
      add_activity(excluded, end_date: Date.new(2022, 1, 31))

      visit view_several_legacy_people_path(legacy_people_ids: "#{first.id},#{second.id}")

      expect(page).to have_content("Jane Example")
      expect(page).to have_content("Alex Rivera")
      expect(page).not_to have_content("Sam Taylor")
    end

    it "renders an empty table when no IDs are requested" do
      create_legacy_person(name: "Jane Example", dni: "111")

      visit view_several_legacy_people_path(legacy_people_ids: "")

      expect(page).to have_content("Legacy People")
      expect(page).not_to have_content("Jane Example")
    end
  end
end
