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
      expect(page).to have_content("Presente Beneficio Revocado")
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

    it "filters people by current situation" do
      create_origin_person(name: "Casey Example", dni: "1234567890", situation: :presente_beneficio_revocado)
      create_origin_person(name: "Morgan Rivera", dni: "9876543210", situation: :presente)

      visit origin_people_path(situacion_actual: OriginPerson.situacion_actuals.fetch("presente_beneficio_revocado"))

      expect(page).to have_content("Casey Example")
      expect(page).not_to have_content("Morgan Rivera")
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

  describe "GET /origin_people/:id" do
    it "shows demographic details, age, and sentenced legal process data" do
      person = create_origin_person(name: "Casey Example", dni: "1234567890")
      person.update!(dni_kind: "CEDULA", sexo: :mujer)
      person.create_origin_person_demographic!(
        pais_origen: "Ecuador",
        fecha_nacimiento: Date.new(Date.today.year - 34, 1, 1),
        estado_civil: "Soltera",
        nivel_instruccion: "Superior",
        profesion: "Docente"
      )
      process = person.origin_person_legal_processes.create!(
        proceso_num: "CASE-DETAIL-001",
        estado: :con_sentencia,
        fecha_delito: Date.new(2019, 12, 1),
        fecha_detencion: Date.new(2020, 2, 3),
        fecha_ingreso: Date.new(2020, 2, 4),
        fecha_sentencia: Date.new(2020, 1, 15),
        infraccion: "Robo",
        normativa: "COIP",
        observaciones: "Case detail note",
        anios_sentencia: 4
      )
      OriginPersonLegalPenalty.create!(
        origin_person: person,
        origin_person_legal_process: process,
        cantidad_total_sentencia_str: "1530",
        termina_condena_at_str: Date.new(2030, 4, 3),
        veinte_porciento_at_str: Date.new(2022, 1, 1)
      )

      visit origin_person_path(person)

      expect(page).to have_content("Casey Example")
      expect(page).to have_content("Ecuador")
      expect(page).to have_content("Soltera")
      expect(page).to have_content("Docente")
      expect(page).to have_content("34")
      expect(page).to have_content("CASE-DETAIL-001")
      expect(page).to have_content("Case detail note")
      expect(page).to have_content("1530")
    end

    it "shows in-process legal cases without sentence details" do
      person = create_origin_person(name: "Morgan Rivera", dni: "9876543210")
      person.update!(dni_kind: "CEDULA", sexo: :hombre)
      person.create_origin_person_demographic!(
        pais_origen: "Ecuador",
        fecha_nacimiento: Date.new(1992, 6, 10),
        estado_civil: "Soltero",
        nivel_instruccion: "Basica",
        profesion: "Carpintero"
      )
      person.origin_person_legal_processes.create!(
        proceso_num: "CASE-IN-PROGRESS",
        estado: :en_proceso,
        infraccion: "Robo"
      )

      visit origin_person_path(person)

      expect(page).to have_content("CASE-IN-PROGRESS")
      expect(page).to have_content("Proceso 1 sin sentencia")
      expect(page).not_to have_content("Sentencia 1 ·")
    end
  end
end
