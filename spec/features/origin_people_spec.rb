require "rails_helper"

RSpec.describe "Origin people", type: :feature do
  def create_origin_person(name:, dni:, situation: :presente)
    parts = name.split(" ")
    OriginPerson.create!(
      fecha_registro: Date.new(2024, 1, 15),
      father_lastname: parts[0],
      mother_lastname: parts[1],
      first_name: parts[2] || "",
      middle_name: parts[3],
      dni: dni,
      situacion_actual: situation
    )
  end

  def add_legal_process(person, process_num:, offense: "Robo")
    process = person.origin_person_legal_processes.create!(
      proceso_num: process_num,
      estado: :con_sentencia,
      fecha_detencion: Date.new(2020, 2, 3),
      fecha_delito: Date.new(2019, 12, 1),
      anios_sentencia: 4,
      meses_sentencia: 2,
      fecha_sentencia: Date.new(2020, 1, 15),
      infraccion: offense,
      observaciones: "Case note"
    )
    OriginPersonLegalPenalty.create!(
      origin_person: person,
      origin_person_legal_process: process,
      termina_condena_at_str: Date.new(2030, 4, 3),
      veinte_porciento_at_str: Date.new(2022, 1, 1),
      sesenta_porciento_at_str: Date.new(2026, 1, 1)
    )
    process
  end

  describe "GET /origin_people" do
    it "displays people, legal process details, and sentence milestones" do
      person = create_origin_person(name: "Casey Example", dni: "1234567890", situation: :presente_beneficio_revocado)
      add_legal_process(person, process_num: "CASE-2024-001")

      visit origin_people_path

      expect(page).to have_content("Información jurídica")
      expect(page).to have_content("Casey Example")
      expect(page).to have_content("1234567890")
      expect(page).to have_content("presente_beneficio_revocado")
      expect(page).to have_content("CASE-2024-001")
      expect(page).to have_content("Con Sentencia")
      expect(page).to have_content("Robo")
      expect(page).to have_content("4 Años")
      expect(page).to have_content("2 Meses")
      expect(page).to have_content("2030-04-03") # termina_condena_at
      expect(page).to have_content("2022-01-01") # veinte_porciento_at
      expect(page).to have_content("2026-01-01") # sesenta_porciento_at
    end

    it "filters by partial name or DNI" do
      create_origin_person(name: "Casey Example", dni: "1234567890")
      create_origin_person(name: "Morgan Rivera", dni: "9876543210")

      visit origin_people_path(s: "12345")

      expect(page).to have_content("Casey Example")
      expect(page).not_to have_content("Morgan Rivera")

      visit origin_people_path(s: "Morgan")

      expect(page).to have_content("Morgan Rivera")
      expect(page).not_to have_content("Casey Example")
    end

    it "filters people by a partial process number" do
      matching_person = create_origin_person(name: "Casey Example", dni: "1234567890")
      other_person = create_origin_person(name: "Morgan Rivera", dni: "9876543210")
      add_legal_process(matching_person, process_num: "CASE-2024-001")
      add_legal_process(other_person, process_num: "OTHER-2024-002")

      visit origin_people_path(proceso_num: "2024-001")

      expect(page).to have_content("Casey Example")
      expect(page).not_to have_content("Morgan Rivera")
      expect(page).to have_content("CASE-2024-001")
    end

    it "ignores search strings shorter than three characters" do
      create_origin_person(name: "Casey Example", dni: "1234567890")
      create_origin_person(name: "Morgan Rivera", dni: "9876543210")

      visit origin_people_path(s: "Ca")

      expect(page).to have_content("Casey Example")
      expect(page).to have_content("Morgan Rivera")
    end

    it "renders the page without people when the filters match nothing" do
      create_origin_person(name: "Casey Example", dni: "1234567890")

      visit origin_people_path(s: "Nobody")

      expect(page).to have_content("Información jurídica")
      expect(page).not_to have_content("Casey Example")
    end
  end
end
