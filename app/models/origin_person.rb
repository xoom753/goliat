class OriginPerson < ApplicationRecord
    before_save :set_fullname!
    before_save :set_situacion_actual!

    attr_accessor :situacion_actual_str

    has_one :origin_person_demographic
    has_many :origin_person_legal_processes
    has_many :origin_person_legal_penalties

    enum :sexo, {
        hombre: 0,
        mujer: 1
    }

    enum :situacion_actual, {
        presente: 0,
        presente_beneficio_revocado: 1,
        libre: 2,
        regimen_semiabierto: 3,
        traslado_hacia_otro_cpl: 4,
        prelibertad: 5,
        fallecimiento_por_muerte_natural: 6,
        libre_con_medida_cautelar_arresto_domiciliario: 7,
        regimen_abierto: 8,
        libertad_controlada: 9,
        fugado_en_centro_medico: 10,
        fallecimiento_por_suicidio: 11,
        fallecimiento_por_causa_accidental: 12,
        fallecimiento_por_violencia_intracarcelaria: 13,
        fallecimiento_fuera_del_cpl: 14,
        libre_con_medida_cautelar_presentacion_ante_autoridad_competente: 15,
        libre_con_medida_cautelar_dispositivos_de_vigilancia_electronica: 16
    }

    private

    def set_fullname!
        self.fullname = [
            father_lastname,
            mother_lastname,
            first_name,
            middle_name
        ].reject(&:blank?).join(" ")
    end

    def set_situacion_actual!
        return if situacion_actual_str.blank?
        # _LIBRE => LIBRE => libre
        # _LIBERTAD CONTROLADA => LIBERTAD CONTROLADA => libertad_controlada
        self.situacion_actual = situacion_actual_str.sub(/^_/, "").parameterize.underscore
    end
end
