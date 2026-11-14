class Activity < ApplicationRecord
  belongs_to :activity_group
  has_many :person_activities, as: :coursable

  scope :order_by_name, -> {
    order(nombre: :asc)
  }
end
