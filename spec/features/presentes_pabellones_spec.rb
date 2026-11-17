require "rails_helper"

RSpec.describe "Present people by pavilion", type: :feature do
  it "lists present people grouped by pavilion with their cells" do
    Person.create!(nombres: "Jane Example", dni: "111", estado: :presente, pabellon: "A-1", celda: "101")
    Person.create!(nombres: "Alex Rivera", dni: "222", estado: :presente, pabellon: "B-2", celda: "202")
    Person.create!(nombres: "Morgan Taylor", dni: "333", estado: :libre, pabellon: "A-1", celda: "103")

    visit presentes_pabellones_path

    expect(page).to have_content("Pabellones y celdas (PPL presentes)")
    expect(page).to have_content("Pabellón: A-1")
    expect(page).to have_content("Pabellón: B-2")
    expect(page).to have_content("Jane Example")
    expect(page).to have_content("111")
    expect(page).to have_content("101")
    expect(page).to have_content("Alex Rivera")
    expect(page).not_to have_content("Morgan Taylor")
  end

  it "filters the listing to the selected pavilion" do
    Person.create!(nombres: "Jane Example", dni: "111", estado: :presente, pabellon: "A-1", celda: "101")
    Person.create!(nombres: "Alex Rivera", dni: "222", estado: :presente, pabellon: "B-2", celda: "202")

    visit presentes_pabellones_path(pabellon: "A-1")

    expect(page).to have_content("Jane Example")
    expect(page).not_to have_content("Alex Rivera")
    expect(page).to have_link("A-1", href: presentes_pabellones_path(pabellon: "A-1"))
  end

  it "renders the page when no present people exist" do
    Person.create!(nombres: "Morgan Taylor", dni: "333", estado: :libre, pabellon: "A-1", celda: "103")

    visit presentes_pabellones_path

    expect(page).to have_content("Pabellones y celdas (PPL presentes)")
    expect(page).not_to have_content("Morgan Taylor")
  end
end
