class ImportOriginPeopleTask
    def initialize(xlsx)
        @xlsx = xlsx
        @sheet = @xlsx.sheet(0)
        @sheet_headers = {
            # person_attributes
            fecha_registro: "FECHA FIN REGISTRO",
            father_lastname: "PRIMER APELLIDO PPL",
            mother_lastname: "SEGUNDO APELLIDO PPL",
            first_name: "PRIMER NOMBRE PPL",
            middle_name: "SEGUNDO NOMBRE PPL",
            alias_name: "ALIAS U OTRO NOMBRE",
            dni_kind: "TIPO DE DOCUMENTO DE IDENTIDAD",
            dni: "NUMERO DE DOCUMENTO DE IDENTIDAD",
            situacion_actual_str: "SITUACION ACTUAL",
            # demographic_attributes
            pais_origen: "PAIS DE ORIGEN",
            fecha_nacimiento: "FECHA DE NACIMIENTO",
            estado_civil: "ESTADO CIVIL",
            nivel_instruccion: "NIVEL DE INSTRUCCION",
            profesion: "PROFESION - OCUPACION  ANTES DE LA DETENCION (EN QUE TRABAJABA ANTES DE SU DETENCION)",
            gravedad_enfermedad: "GRAVEDAD DE LA ENFERMEDAD",
            tipo_enfermedad: "TIPO DE ENFERMEDAD ESPECÍFICA",
            tipo_discapacidad: "TIPO DE DISCAPACIDAD",
            # legal_process_attributes
            fecha_detencion: "FECHA DE DETENCION O FECHA DE PERDIDA DE LIBERTAD",
            fecha_delito: "FECHA DE COMETIMIENTO DEL DELITO O INFRACCION",
            fecha_ingreso: "FECHA DE INGRESO AL SISTEMA PENITENCIARIO CPL",
            estado_str: "CON SENTENCIA",
            anios_sentencia: "AÑOS DE SENTENCIA",
            meses_sentencia: "MESES DE SENTENCIA",
            dias_sentencia: "DIAS DE SENTENCIA",
            fecha_sentencia: "FECHA DE SENTENCIA",
            boleta_encarcelamiento: "NO. BOLETA DE ENCARCELAMIENTO",
            fecha_boleta_encarcelamiento: "FECHA DE EMISION DE BOLETA DE ENCARCELAMIENTO",
            proceso_num: "NO. PROCESO O JUICIO O CAUSA DE INGRESO",
            normativa: "NORMATIVA",
            infraccion: "INFRACCION",
            incisos: "INCISOS, NUMERALES, LITERALES (INC,NUM,LIT)",
            grupo_infraccion: "GRUPO DE INFRACCION",
            subgrupo_infraccion: "SUBGRUPO DE INFRACCION",
            parte_policial_num: "NUMERO DE PARTE POLICIAL",
            observaciones: "OBSERVACIONES",
            observaciones_2: "OBSERVACIONES 2",
            # legal_penalty_attributes
            anios_acumulacion_pena: "AÑOS ACUMULACION DE PENA",
            meses_acumulacion_pena: "MESES ACUMULACION DE PENAS",
            dias_acumulacion_pena: "DIAS ACUMULACION DE PENAS",
            acumulacion_total_penas: "ACUMULACION TOTAL DE PENAS",
            anios_pena_individual: "AÑOS PENA INDIVIDUAL",
            meses_pena_individual: "MESES PENA INDIVIDUAL",
            dias_pena_individual: "DIAS PENA INDIVIDUAL",
            acumulacion_pena_individual_total: "ACUMULACION PENA INDIVIDUAL TOTAL",
            cantidad_total_sentencia_str: "CANTIDAD TOTAL DE  SENTENCIA",
            termina_condena_at_str: "TERMINA CONDENA",
            veinte_porciento_at_str: "CUMPLE 20EN",
            cuarenta_porciento_at_str: "CUMPLE 40EN",
            sesenta_porciento_at_str: "CUMPLE 60EN",
            ochenta_porciento_at_str: "CUMPLE 80EN"
        }
    end

    def import!
        import_count = 0
        parsing_first_row = true
        @sheet.each(@sheet_headers) do |hash|
            if parsing_first_row
                parsing_first_row = false
            elsif hash[:father_lastname].present?
                origin_person = find_or_create_person(hash)
                origin_person.update!(
                    fecha_registro: hash[:fecha_registro],
                    father_lastname: hash[:father_lastname].to_s.strip,
                    mother_lastname: hash[:mother_lastname].to_s.strip,
                    first_name: hash[:first_name].to_s.strip,
                    middle_name: hash[:middle_name].to_s.strip,
                    alias_name: hash[:alias_name].to_s.strip,
                    dni_kind: hash[:dni_kind],
                    dni: hash[:dni],
                    situacion_actual_str: hash[:situacion_actual_str]
                )
                origin_person_demographic = origin_person.origin_person_demographic || origin_person.build_origin_person_demographic
                origin_person_demographic.update!(
                    pais_origen: hash[:pais_origen],
                    fecha_nacimiento: hash[:fecha_nacimiento],
                    estado_civil: hash[:estado_civil],
                    nivel_instruccion: hash[:nivel_instruccion],
                    profesion: hash[:profesion],
                    gravedad_enfermedad: hash[:gravedad_enfermedad],
                    tipo_enfermedad: hash[:tipo_enfermedad],
                    tipo_discapacidad: hash[:tipo_discapacidad]
                )
                origin_person_legal_process = origin_person.origin_person_legal_processes.where(
                    proceso_num: hash[:proceso_num]
                ).first_or_initialize
                origin_person_legal_process.update!(
                    fecha_detencion: hash[:fecha_detencion],
                    fecha_delito: hash[:fecha_delito],
                    fecha_ingreso: hash[:fecha_ingreso],
                    estado_str: hash[:estado_str],
                    anios_sentencia: hash[:anios_sentencia],
                    meses_sentencia: hash[:meses_sentencia],
                    dias_sentencia: hash[:dias_sentencia],
                    fecha_sentencia: hash[:fecha_sentencia],
                    boleta_encarcelamiento: hash[:boleta_encarcelamiento],
                    fecha_boleta_encarcelamiento: hash[:fecha_boleta_encarcelamiento],
                    normativa: hash[:normativa],
                    infraccion: hash[:infraccion],
                    incisos: hash[:incisos],
                    grupo_infraccion: hash[:grupo_infraccion],
                    subgrupo_infraccion: hash[:subgrupo_infraccion],
                    parte_policial_num: hash[:parte_policial_num],
                    observaciones: hash[:observaciones],
                    observaciones_2: hash[:observaciones_2]
                )
                origin_person_legal_penalty = origin_person.origin_person_legal_penalties.where(
                    origin_person_legal_process: origin_person_legal_process
                ).first_or_initialize
                origin_person_legal_penalty.update!(
                    anios_acumulacion_pena: hash[:anios_acumulacion_pena],
                    meses_acumulacion_pena: hash[:meses_acumulacion_pena],
                    dias_acumulacion_pena: hash[:dias_acumulacion_pena],
                    acumulacion_total_penas: hash[:acumulacion_total_penas],
                    anios_pena_individual: hash[:anios_pena_individual],
                    meses_pena_individual: hash[:meses_pena_individual],
                    dias_pena_individual: hash[:dias_pena_individual],
                    acumulacion_pena_individual_total: hash[:acumulacion_pena_individual_total],
                    cantidad_total_sentencia_str: hash[:cantidad_total_sentencia_str],
                    termina_condena_at_str: hash[:termina_condena_at_str],
                    veinte_porciento_at_str: hash[:veinte_porciento_at_str],
                    cuarenta_porciento_at_str: hash[:cuarenta_porciento_at_str],
                    sesenta_porciento_at_str: hash[:sesenta_porciento_at_str],
                    ochenta_porciento_at_str: hash[:ochenta_porciento_at_str]
                )
                puts origin_person.fullname
                import_count += 1
            end
        end
        puts "imported #{import_count} records"
    end

    private

    def find_or_create_person(hash)
        fullname = [
            hash[:father_lastname].to_s.strip,
            hash[:mother_lastname].to_s.strip,
            hash[:first_name].to_s.strip,
            hash[:middle_name].to_s.strip
        ].reject(&:blank?).join(" ")
        OriginPerson.where(
            fullname: fullname,
            dni: hash[:dni]
        ).first_or_initialize
    end
end
