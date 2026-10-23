class Person < ApplicationRecord
    enum :estado, {
        presente: 0,
        libre: 1,
        indefinido: 2
    }
    has_many :person_activities
end
