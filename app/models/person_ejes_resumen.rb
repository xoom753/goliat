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

    def people
        Person.find(
            people_ids.split(",")
        )
    end

    def update_last_generated_at!
        update!(last_generated_at: Time.now)
    end
end
