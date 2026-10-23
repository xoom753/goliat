class CreateOriginPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :origin_people do |t|
      t.date :fecha_registro, null: false
      t.string :father_lastname, null: false
      t.string :mother_lastname
      t.string :first_name, null: false
      t.string :middle_name
      t.string :fullname, null: false
      t.string :alias_name
      t.string :dni_kind
      t.string :dni
      t.integer :situacion_actual, default: 0

      t.timestamps
    end
    add_index :origin_people, [:fullname, :dni]
  end
end
