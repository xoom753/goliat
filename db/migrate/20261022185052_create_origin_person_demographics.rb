class CreateOriginPersonDemographics < ActiveRecord::Migration[8.1]
  def change
    create_table :origin_person_demographics do |t|
      t.string :pais_origen
      t.date :fecha_nacimiento
      t.string :estado_civil
      t.string :nivel_instruccion
      t.string :profesion
      t.string :gravedad_enfermedad
      t.string :tipo_enfermedad
      t.string :tipo_discapacidad
      t.references :origin_person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
