class ExtranjeroPresente < ApplicationRecord
    # strip whitespaces
    def nombres_str=(nombres_str)
        self.nombres = nombres_str.split(" ").map do |word|
            word.strip.titleize
        end.join(" ")
    end

    def person
        @person ||= Person.where(
            nombres: nombres.upcase
        ).first
    end

    def legacy_people
        @legacy_people ||= LegacyPerson.where(
            nombres: nombres.upcase
        )
    end

    def legacy_people_ids
        legacy_people.map(&:id)
    end
end
