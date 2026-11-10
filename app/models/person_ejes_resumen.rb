class PersonEjesResumen < ApplicationRecord
    def delitos_array
        @delitos_array ||= delitos.split("\n")
    end

    def several_delitos?
        delitos_array.length > 1
    end

    def sentencias_array
        @sentencias_array ||= sentencias.split("\n")
    end

    def legacy_people
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

    ##
    # 2022-06-02 => "02/06/2022"
    def self.date_to_str(date)
        date.strftime("%d/%m/%Y")
    end
end
