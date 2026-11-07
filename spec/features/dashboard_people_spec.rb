require "rails_helper"

RSpec.describe "Dashboard people", type: :feature do
  let!(:cultural_group) { ActivityGroup.create!(nombre: "Eje Cultural") }
  let!(:sports_group) { ActivityGroup.create!(nombre: "Sports") }
  let!(:painting) { Activity.create!(nombre: "Painting", activity_group: cultural_group) }
  let!(:music) { Activity.create!(nombre: "Music", activity_group: cultural_group) }
  let!(:football) { Activity.create!(nombre: "Football", activity_group: sports_group) }

  describe "people list" do
    it "shows people identifiers, pavilion, process links, and group activity status" do
      person = Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1")
      PersonActivity.create!(person: person, coursable: painting, mes: 3, anio: 2024, cargo: :instructor)

      visit people_dashboard_path

      expect(page).to have_content("Jane Example")
      expect(page).to have_content("1234567890")
      expect(page).to have_content("A 1")
      expect(page).to have_content("ID: #{person.id}")
      expect(page).to have_link("Ver procesos", href: origin_people_path(s: "Jane Example"))
      expect(page).to have_link("Ver procesos", href: origin_people_path(s: "1234567890"))
      expect(page).to have_content("Cultural")
      expect(page).to have_content("Painting")
      expect(page).to have_content("March 2024: instructor")
      expect(page).to have_content("Music")
      ##
      # for now only showing Cultural, Deportivo & Laboral
      # expect(page).to have_content("Football")
      expect(page).to_not have_content("Football")
      expect(page).to have_content("-")
    end

    describe "for now only showing Cultural, Deportivo & Laboral" do
      let!(:cultural_group) { ActivityGroup.create!(nombre: "Eje Cultural") }
      let!(:deportivo_group) { ActivityGroup.create!(nombre: "Eje Deportivo") }
      let!(:laboral_group) { ActivityGroup.create!(nombre: "Eje Laboral") }
      let!(:sports_group) { ActivityGroup.create!(nombre: "Sports") }
      let!(:person) { Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1") }

      it {
        visit people_dashboard_path
        expect(page).to have_content("Cultural")
        expect(page).to have_content("Deportivo")
        expect(page).to have_content("Laboral")
        expect(page).to_not have_content("Educativo")
      }
    end

    it "filters people by a query longer than two characters" do
      Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1")
      Person.create!(nombres: "Alex Rivera", dni: "9999999999", pabellon: "B-2")

      visit people_dashboard_path(s: "Jane")

      expect(page).to have_content("Jane Example")
      expect(page).not_to have_content("Alex Rivera")
    end

    it "searches DNI values as well as names" do
      Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1")
      Person.create!(nombres: "Alex Rivera", dni: "9999999999", pabellon: "B-2")

      visit people_dashboard_path(s: "999")

      expect(page).to have_content("Alex Rivera")
      expect(page).not_to have_content("Jane Example")
    end

    it "ignores one- and two-character search strings" do
      Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1")
      Person.create!(nombres: "Alex Rivera", dni: "9999999999", pabellon: "B-2")

      visit people_dashboard_path(s: "Ja")

      expect(page).to have_content("Jane Example")
      expect(page).to have_content("Alex Rivera")
    end

    it "filters by person_id and shows an empty state for a missing person" do
      person = Person.create!(nombres: "Jane Example", dni: "1234567890", pabellon: "A-1")
      Person.create!(nombres: "Alex Rivera", dni: "9999999999", pabellon: "B-2")

      visit people_dashboard_path(person_id: person.id)

      expect(page).to have_content("Jane Example")
      expect(page).not_to have_content("Alex Rivera")

      visit people_dashboard_path(person_id: -1)

      expect(page).not_to have_content("Jane Example")
      expect(page).not_to have_content("Alex Rivera")
    end
  end
end
