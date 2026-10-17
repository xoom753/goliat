class PersonActivity < ApplicationRecord
  belongs_to :person
  belongs_to :coursable, polymorphic: true
  enum :cargo, {
        estudiante: 0,
        instructor: 1,
        apoyo: 2, # instructor de apoyo
        independiente: 3,
        responsable: 4,
        cuentapropia: 5
    }
end
