require "rails_helper"

RSpec.describe ImportOriginPeopleTask do
  let(:sheet) { double }
  let(:xlsx) { double(sheet: sheet) }
  subject(:task) { described_class.new(xlsx) }

  let(:person_row) do
    {
      fecha_registro: Date.new(2024, 1, 10),
      father_lastname: "  PEREZ ",
      mother_lastname: " LOPEZ ",
      first_name: " ANA ",
      middle_name: " MARIA ",
      alias_name: " ANITA ",
      dni_kind: "CEDULA",
      dni: "1234567890",
      situacion_actual_str: "PRESENTE",
      pais_origen: "Ecuador",
      fecha_nacimiento: Date.new(1990, 5, 6),
      estado_civil: "Soltera",
      nivel_instruccion: "Superior",
      profesion: "Docente",
      gravedad_enfermedad: "Baja",
      tipo_enfermedad: "Ninguna",
      tipo_discapacidad: "Ninguna",
      fecha_detencion: Date.new(2020, 2, 3),
      fecha_delito: Date.new(2019, 12, 1),
      fecha_ingreso: Date.new(2020, 2, 4),
      estado_str: "CON SENTENCIA",
      anios_sentencia: 4,
      meses_sentencia: 2,
      dias_sentencia: 0,
      fecha_sentencia: Date.new(2020, 1, 15),
      boleta_encarcelamiento: "B-123",
      fecha_boleta_encarcelamiento: Date.new(2020, 2, 3),
      proceso_num: "CASE-001",
      normativa: "COIP",
      infraccion: "Robo",
      incisos: "1",
      grupo_infraccion: "Delitos contra la propiedad",
      subgrupo_infraccion: "Robo",
      parte_policial_num: "P-123",
      observaciones: "Observación",
      observaciones_2: "Otra observación",
      anios_acumulacion_pena: 4,
      meses_acumulacion_pena: 2,
      dias_acumulacion_pena: 0,
      acumulacion_total_penas: 1530,
      anios_pena_individual: 4,
      meses_pena_individual: 2,
      dias_pena_individual: 0,
      acumulacion_pena_individual_total: 1530,
      cantidad_total_sentencia_str: "1530",
      termina_condena_at_str: "2030-04-03",
      veinte_porciento_at_str: "2022-01-01",
      cuarenta_porciento_at_str: "2024-01-01",
      sesenta_porciento_at_str: "2026-01-01",
      ochenta_porciento_at_str: "2028-01-01"
    }
  end

  def stub_sheet_rows(*rows)
    allow(sheet).to receive(:each) do |headers, &block|
      expect(headers).to include(
        fecha_registro: "FECHA FIN REGISTRO",
        father_lastname: "PRIMER APELLIDO PPL",
        proceso_num: "NO. PROCESO O JUICIO O CAUSA DE INGRESO"
      )
      rows.each(&block)
    end
  end

  it "skips the header and blank-name rows, normalizes data, and creates related records" do
    stub_sheet_rows({}, person_row, person_row.merge(father_lastname: " "))

    expect { task.import! }.to output(/PEREZ LOPEZ ANA MARIA\nimported 1 records/).to_stdout

    person = OriginPerson.find_by!(dni: "1234567890")
    expect(person).to have_attributes(
      fullname: "PEREZ LOPEZ ANA MARIA",
      father_lastname: "PEREZ",
      mother_lastname: "LOPEZ",
      first_name: "ANA",
      middle_name: "MARIA",
      alias_name: "ANITA",
      dni_kind: "CEDULA",
      situacion_actual: "presente"
    )

    demographic = person.origin_person_demographic
    expect(demographic).to have_attributes(
      pais_origen: "Ecuador",
      fecha_nacimiento: Date.new(1990, 5, 6),
      estado_civil: "Soltera",
      profesion: "Docente"
    )

    legal_process = person.origin_person_legal_processes.find_by!(proceso_num: "CASE-001")
    expect(legal_process).to have_attributes(
      estado: "con_sentencia",
      fecha_detencion: Date.new(2020, 2, 3),
      infraccion: "Robo",
      observaciones: "Observación"
    )

    penalty = person.origin_person_legal_penalties.find_by!(origin_person_legal_process: legal_process)
    expect(penalty).to have_attributes(
      cantidad_total_sentencia: 1530,
      termina_condena_at: Date.new(2030, 4, 3),
      veinte_porciento_at: Date.new(2022, 1, 1),
      ochenta_porciento_at: Date.new(2028, 1, 1)
    )
  end

  it "updates the existing person, process, demographic, and penalty on a repeated import" do
    stub_sheet_rows({}, person_row)
    expect { task.import! }.to output(/imported 1 records/).to_stdout

    revised_row = person_row.merge(
      profesion: "Directora",
      infraccion: "Hurto",
      cantidad_total_sentencia_str: "EN PROCESO",
      termina_condena_at_str: "EN PROCESO"
    )
    stub_sheet_rows({}, revised_row)
    expect { task.import! }.to output(/imported 1 records/).to_stdout

    expect(OriginPerson.count).to eq(1)
    person = OriginPerson.find_by!(dni: "1234567890")
    expect(person.origin_person_demographic.profesion).to eq("Directora")
    expect(person.origin_person_legal_processes.count).to eq(1)
    expect(person.origin_person_legal_processes.first.infraccion).to eq("Hurto")
    expect(person.origin_person_legal_penalties.count).to eq(1)
    expect(person.origin_person_legal_penalties.first.cantidad_total_sentencia).to eq(1530)
    expect(person.origin_person_legal_penalties.first.termina_condena_at).to eq(Date.new(2030, 4, 3))
  end
end
