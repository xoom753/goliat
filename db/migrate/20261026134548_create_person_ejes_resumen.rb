class CreatePersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    create_table :person_ejes_resumenes do |t|
      t.string :nombres, null: false
      t.string :dni, null: false
      t.date :fecha_perdida_libertad, null: false
      t.text :delitos, null: false
      t.text :sentencias, null: false
      t.text :acumulacion_penas
      t.text :semestres_porcentuales, null: false
      t.text :periodos_detalle, null: false

      t.datetime "created_at", null: false
    end
  end
end
