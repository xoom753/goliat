class Person < ApplicationRecord
    enum :estado, {presente: 0, libre: 1}
    has_many :person_activities
end
