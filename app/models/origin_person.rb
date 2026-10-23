class OriginPerson < ApplicationRecord
    before_save :set_fullname!
    before_save :set_situacion_actual!

    attr_accessor :situacion_actual_str

    has_one :origin_person_demographic
    has_many :origin_person_legal_processes
    has_many :origin_person_legal_penalties

    enum :situacion_actual, {
        presente: 0,
        presente_beneficio_revocado: 1
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
        self.situacion_actual = situacion_actual_str.downcase.sub(" ", "_")
    end
end
