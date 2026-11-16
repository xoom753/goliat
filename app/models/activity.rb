class Activity < ApplicationRecord
  belongs_to :activity_group
  has_one :activity_human_name
  has_many :person_activities, as: :coursable

  scope :order_by_name, -> {
    order(nombre: :asc)
  }

  def human_name
    if activity_human_name.present?
      activity_human_name.nombre
    else
      nombre
    end
  end
end
