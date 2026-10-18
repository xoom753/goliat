class LegacyActivityGroup < ApplicationRecord
    has_many :legacy_person_activities
    belongs_to :activity_group, optional: true
end
