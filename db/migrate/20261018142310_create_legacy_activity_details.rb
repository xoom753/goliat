class CreateLegacyActivityDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_activity_details do |t|
      t.string :nombre, null: false

      t.datetime "created_at", null: false
    end
    add_index :legacy_activity_details, :nombre
  end
end
