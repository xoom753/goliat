require "rails_helper"

RSpec.describe ImportBateriaIndicadoresTask::BateriaIndicadoresRow do
  let(:config) { Rails.application.config_for(:bateria_indicadores) }
  let(:headers) { config[:headers] }
  let(:row) { Array.new(headers.length) }
  subject(:import_row) { described_class.new(row) }

  def set_cell(header, value)
    row[headers.index(header)] = value
  end

  def set_valid_person_fields
    {
      "FECHA FIN REGISTRO" => Date.new(2024, 1, 10),
      "PRIMER APELLIDO PPL" => " PEREZ ",
      "SEGUNDO APELLIDO PPL" => " LOPEZ ",
      "PRIMER NOMBRE PPL" => " ANA ",
      "SEGUNDO NOMBRE PPL" => " MARIA ",
      "ALIAS U OTRO NOMBRE" => " ANITA ",
      "TIPO DE DOCUMENTO DE IDENTIDAD" => "CEDULA",
      "NUMERO DE DOCUMENTO DE IDENTIDAD" => "1234567890",
      "SITUACION ACTUAL" => "PRESENTE",
      "SEXO" => "MUJER",
      "PAIS DE ORIGEN" => "Ecuador",
      "FECHA DE NACIMIENTO" => Date.new(1990, 5, 6),
      "ESTADO CIVIL" => "Soltera",
      "NIVEL DE INSTRUCCION" => "Superior",
      "PROFESION - OCUPACION  ANTES DE LA DETENCION (EN QUE TRABAJABA ANTES DE SU DETENCION)" => "Docente",
      "FECHA DE DETENCION O FECHA DE PERDIDA DE LIBERTAD" => Date.new(2020, 2, 3),
      "FECHA DE COMETIMIENTO DEL DELITO O INFRACCION" => Date.new(2019, 12, 1),
      "FECHA DE INGRESO AL SISTEMA PENITENCIARIO CPL" => Date.new(2020, 2, 4),
      "CON SENTENCIA" => "CON SENTENCIA",
      "AÑOS DE SENTENCIA" => 4,
      "MESES DE SENTENCIA" => 2,
      "NO. BOLETA DE ENCARCELAMIENTO" => "B-123",
      "NO. PROCESO O JUICIO O CAUSA DE INGRESO" => "CASE-ROW-001",
      "INFRACCION" => "Robo",
      "OBSERVACIONES" => "Observación",
      "AÑOS ACUMULACION DE PENA" => 4,
      "ACUMULACION TOTAL DE PENAS" => 1530,
      "CANTIDAD TOTAL DE  SENTENCIA" => "1530",
      "TERMINA CONDENA" => "2030-04-03",
      "CUMPLE 20% EN " => "2022-01-01",
      "CUMPLE 40% EN " => "2024-01-01",
      "CUMPLE 60% EN " => "2026-01-01",
      "CUMPLE 80% EN " => "2028-01-01"
    }.each { |header, value| set_cell(header, value) }
  end

  it "skips rows without a first surname" do
    expect(import_row.import!).to be(false)
    expect(import_row.fullname).to be_nil
    expect(OriginPerson.count).to eq(0)
  end

  it "imports a person with normalized name fields and related records" do
    set_valid_person_fields

    expect(import_row.import!).to be(true)
    expect(import_row.fullname).to eq("PEREZ LOPEZ ANA MARIA")

    person = OriginPerson.find_by!(dni: "1234567890")
    expect(person).to have_attributes(
      fullname: "PEREZ LOPEZ ANA MARIA",
      father_lastname: "PEREZ",
      mother_lastname: "LOPEZ",
      first_name: "ANA",
      middle_name: "MARIA",
      alias_name: "ANITA",
      situacion_actual: "presente",
      sexo: "mujer"
    )
    expect(person.origin_person_demographic).to have_attributes(pais_origen: "Ecuador", profesion: "Docente")
    legal_process = person.origin_person_legal_processes.find_by!(proceso_num: "CASE-ROW-001")
    expect(legal_process).to have_attributes(estado: "con_sentencia", infraccion: "Robo")
    expect(person.origin_person_legal_penalties.find_by!(origin_person_legal_process: legal_process)).to have_attributes(
      cantidad_total_sentencia: 1530,
      termina_condena_at: Date.new(2030, 4, 3),
      veinte_porciento_at: Date.new(2022, 1, 1),
      ochenta_porciento_at: Date.new(2028, 1, 1)
    )
  end

  it "updates an existing person and reuses the matching process and penalty" do
    set_valid_person_fields
    expect(import_row.import!).to be(true)
    set_cell("PROFESION - OCUPACION  ANTES DE LA DETENCION (EN QUE TRABAJABA ANTES DE SU DETENCION)", "Directora")
    set_cell("INFRACCION", "Hurto")

    expect(import_row.import!).to be(true)

    person = OriginPerson.find_by!(dni: "1234567890")
    expect(OriginPerson.count).to eq(1)
    expect(person.origin_person_demographic.profesion).to eq("Directora")
    expect(person.origin_person_legal_processes.count).to eq(1)
    expect(person.origin_person_legal_processes.first.infraccion).to eq("Hurto")
    expect(person.origin_person_legal_penalties.count).to eq(1)
  end
end
