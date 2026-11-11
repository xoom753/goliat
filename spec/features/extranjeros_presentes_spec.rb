require "rails_helper"

RSpec.describe "Extranjeros presentes", type: :feature do
  it "shows passport holders and links matched present and legacy people" do
    present_person = Person.create!(nombres: "MARIA LOPEZ", dni: "111")
    legacy_person = LegacyPerson.create!(nombres: "MARIA LOPEZ", dni: "222")
    extranjero = ExtranjeroPresente.create!(nombres: "Maria Lopez", pasaporte: "P-123")

    visit extranjeros_presentes_path

    expect(page).to have_content("Extranjeros presentes")
    expect(page).to have_content("Maria Lopez")
    expect(page).to have_content("P-123")
    expect(page).to have_link("Maria Lopez", href: people_dashboard_path(person_id: present_person.id))
    expect(page).to have_link("Maria Lopez", href: legacy_people_path(q: extranjero.nombres))
    expect(legacy_person).to be_persisted
  end

  it "renders unmatched passport holders without person links" do
    ExtranjeroPresente.create!(nombres: "Unknown Person", pasaporte: "P-999")

    visit extranjeros_presentes_path

    expect(page).to have_content("Unknown Person")
    expect(page).to have_content("P-999")
    expect(page).not_to have_link("Unknown Person")
  end
end
