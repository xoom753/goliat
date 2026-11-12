class Person < ApplicationRecord
    enum :estado, {
        presente: 0,
        libre: 1,
        indefinido: 2
    }
    has_many :person_activities

    scope :from_pabellon, ->(pabellon_str) {
        where("pabellon LIKE '%#{pabellon_str}%'")
    }
    scope :from_san_jose, -> {
        from_pabellon("San_Jose")
    }
    scope :not_from_san_jose, -> {
        where.not("pabellon LIKE '%San_Jose%'")
    }
end
