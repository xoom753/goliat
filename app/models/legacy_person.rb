class LegacyPerson < ApplicationRecord
    has_many :legacy_person_activities

    scope :where_nombres_like, ->(search_query) {
        where(
            "nombres LIKE '%#{search_query.strip}%'"
        )
    }
end
