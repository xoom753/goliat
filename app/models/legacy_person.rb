class LegacyPerson < ApplicationRecord
    has_many :legacy_person_activities

    scope :where_nombres_like, ->(search_query) {
        where(
            "nombres ILIKE '%#{search_query.strip}%'"
        )
    }
end
