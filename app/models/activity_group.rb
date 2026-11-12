class ActivityGroup < ApplicationRecord
    has_many :activities
    has_many :legacy_activity_groups
end
