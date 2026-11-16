class ImportBateriaIndicadoresTask::BateriaIndicadoresRow
    attr_reader :fullname

    def initialize(row)
        @row = row
        @headers = Rails.application.config_for(:bateria_indicadores)[:headers]
    end

    def import!
        person_attributes = get_attrs_values_for(:person_attributes)
        if person_attributes[:primer_apellido_ppl].blank?
            # emtpy row
            return false
        end

        origin_person = find_or_initialize_person(person_attributes)
        origin_person.update!(
            fecha_registro: person_attributes[:fecha_fin_registro],
            father_lastname: person_attributes[:primer_apellido_ppl].to_s.strip,
            mother_lastname: person_attributes[:segundo_apellido_ppl].to_s.strip,
            first_name: person_attributes[:primer_nombre_ppl].to_s.strip,
            middle_name: person_attributes[:segundo_nombre_ppl].to_s.strip,
            alias_name: person_attributes[:alias_u_otro_nombre].to_s.strip,
            dni_kind: person_attributes[:tipo_de_documento_de_identidad],
            dni: person_attributes[:numero_de_documento_de_identidad],
            situacion_actual_str: person_attributes[:situacion_actual],
            sexo: person_attributes[:sexo].downcase
        )

        demographic_attributes = get_attrs_values_for(:demographic_attributes)

        origin_person_demographic = origin_person.origin_person_demographic || origin_person.build_origin_person_demographic
        origin_person_demographic.update!(
            pais_origen: demographic_attributes[:pais_de_origen],
            fecha_nacimiento: demographic_attributes[:fecha_de_nacimiento],
            estado_civil: demographic_attributes[:estado_civil],
            nivel_instruccion: demographic_attributes[:nivel_de_instruccion],
            profesion: demographic_attributes[:profesion_ocupacion_antes_de_la_det],
            gravedad_enfermedad: demographic_attributes[:gravedad_de_la_enfermedad],
            tipo_enfermedad: demographic_attributes[:tipo_de_enfermedad_especifica],
            tipo_discapacidad: demographic_attributes[:tipo_de_discapacidad]
        )

        legal_process_attributes = get_attrs_values_for(:legal_process_attributes)
        origin_person_legal_process = origin_person.origin_person_legal_processes.where(
            proceso_num: legal_process_attributes[:no_proceso_o_juicio_o_causa_de_ingr],
            boleta_encarcelamiento: legal_process_attributes[:no_boleta_de_encarcelamiento]
        ).first_or_initialize
        origin_person_legal_process.update!(
            fecha_detencion: legal_process_attributes[:fecha_de_detencion_o_fecha_de_perdi],
            fecha_delito: legal_process_attributes[:fecha_de_cometimiento_del_delito_o_],
            fecha_ingreso: legal_process_attributes[:fecha_de_ingreso_al_sistema_peniten],
            estado_str: legal_process_attributes[:con_sentencia],
            anios_sentencia: legal_process_attributes[:anos_de_sentencia],
            meses_sentencia: legal_process_attributes[:meses_de_sentencia],
            dias_sentencia: legal_process_attributes[:dias_de_sentencia],
            fecha_sentencia: legal_process_attributes[:fecha_de_sentencia],
            fecha_boleta_encarcelamiento: legal_process_attributes[:fecha_de_emision_de_boleta_de_encar],
            normativa: legal_process_attributes[:normativa],
            infraccion: legal_process_attributes[:infraccion],
            incisos: legal_process_attributes[:incisos_numerales_literales_inc_num],
            grupo_infraccion: legal_process_attributes[:grupo_de_infraccion],
            subgrupo_infraccion: legal_process_attributes[:subgrupo_de_infraccion],
            parte_policial_num: legal_process_attributes[:numero_de_parte_policial],
            observaciones: legal_process_attributes[:observaciones],
            observaciones_2: legal_process_attributes[:observaciones_2]
        )

        legal_penalty_attributes = get_attrs_values_for(:legal_penalty_attributes)
        origin_person_legal_penalty = origin_person.origin_person_legal_penalties.where(
            origin_person_legal_process: origin_person_legal_process
        ).first_or_initialize
        origin_person_legal_penalty.update!(
            anios_acumulacion_pena: legal_penalty_attributes[:anos_acumulacion_de_pena],
            meses_acumulacion_pena: legal_penalty_attributes[:meses_acumulacion_de_penas],
            dias_acumulacion_pena: legal_penalty_attributes[:dias_acumulacion_de_penas],
            acumulacion_total_penas: legal_penalty_attributes[:acumulacion_total_de_penas],
            anios_pena_individual: legal_penalty_attributes[:anos_pena_individual],
            meses_pena_individual: legal_penalty_attributes[:meses_pena_individual],
            dias_pena_individual: legal_penalty_attributes[:dias_pena_individual],
            acumulacion_pena_individual_total: legal_penalty_attributes[:acumulacion_pena_individual_total],
            cantidad_total_sentencia_str: legal_penalty_attributes[:cantidad_total_de_sentencia],
            termina_condena_at_str: legal_penalty_attributes[:termina_condena],
            veinte_porciento_at_str: legal_penalty_attributes[:cumple_20_en],
            cuarenta_porciento_at_str: legal_penalty_attributes[:cumple_40_en],
            sesenta_porciento_at_str: legal_penalty_attributes[:cumple_60_en],
            ochenta_porciento_at_str: legal_penalty_attributes[:cumple_80_en]
        )

        return true
    end

    private

    def find_or_initialize_person(hash)
        @fullname = [
            hash[:primer_apellido_ppl].to_s.strip,
            hash[:segundo_apellido_ppl].to_s.strip,
            hash[:primer_nombre_ppl].to_s.strip,
            hash[:segundo_nombre_ppl].to_s.strip
        ].reject(&:blank?).join(" ")

        OriginPerson.where(
            fullname: @fullname,
            dni: hash[:numero_de_documento_de_identidad]
        ).first_or_initialize
    end

    def get_attrs_values_for(namespace)
        get_attrs_cols_for(namespace).inject({}) do |memo, (key, col_n)|
            memo[key.to_sym] = @row[col_n]
            memo
        end
    end

    def get_attrs_cols_for(namespace)
        attributes = Rails.application.config_for(:bateria_indicadores).fetch(namespace)
        attributes.inject({}) do |memo, attr_name|
            key_name = attr_name.parameterize.underscore[0,35]
            memo[key_name] = @headers.index(attr_name)
            memo
        end
    end
end
