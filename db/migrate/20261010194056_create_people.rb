class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      # t.string :apellidos, null: false
      # t.string :nombres
      t.string :nombres, null: false
      t.string :dni
      t.string :pabellon
      t.integer :estado, default: 0

      # t.timestamps
    end
  end
end
