class CreateLegacyPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_people do |t|
      t.string :nombres, null: false
      t.string :dni

      t.datetime "created_at", null: false
    end
    add_index :legacy_people, :nombres
  end
end
