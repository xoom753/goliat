class ActivityHumanName < ApplicationRecord
  belongs_to :activity
  validates :nombre, presence: true
end
