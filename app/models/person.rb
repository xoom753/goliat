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

    scope :from_pabellon, ->(pabellon_str) {
        where("pabellon ILIKE ?", "%#{pabellon_str}%")
    }
    scope :from_san_jose, -> {
        from_pabellon("San_Jose")
    }
    scope :not_from_san_jose, -> {
        where.not("pabellon ILIKE '%San_Jose%'")
    }
end
