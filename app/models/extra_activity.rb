class ExtraActivity < ApplicationRecord
    has_many :person_activities, as: :coursable, dependent: :destroy
end
