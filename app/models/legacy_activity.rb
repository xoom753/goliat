class LegacyActivity < ApplicationRecord
    has_many :legacy_person_activities

    scope :ordered, -> { order(nombre: :asc) }
end
