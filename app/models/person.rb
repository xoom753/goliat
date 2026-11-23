class Person < ApplicationRecord
    enum :estado, {
        presente: 0,
        libre: 1,
        indefinido: 2,
        regimen_semiabierto: 3,
        traslado_hacia_otro_cpl: 4,
        fallecimiento_por_violencia_intracarcelaria: 5
    }
    has_many :person_activities

    scope :from_pabellones, ->(*pabellones) {
        query_str = pabellones.map do |pabellon_str|
            "pabellon ILIKE ?"
        end.join(" OR ")
        args = pabellones.map do |pabellon_str|
            "%#{pabellon_str}%"
        end
        where(query_str, *args)
    }
    scope :from_san_jose, -> {
        from_pabellones("San_Jose", "San_José")
    }
    scope :not_from_san_jose, -> {
        where(
            "NOT pabellon ILIKE '%San_Jose%' \
            AND NOT pabellon ILIKE '%San_José%'"
        )
    }
end
