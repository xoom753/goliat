class PersonEjesResumen < ApplicationRecord
    def delitos_array
        @delitos_array ||= delitos.split("\n")
    end

    def sentencias_array
        @sentencias_array ||= sentencias.split("\n")
    end

    def legacy_people
        # return [] if legacy_people_ids.blank?
        LegacyPerson.find(
            legacy_people_ids.split(",")
        )
    end
end
