class CreateLegacyActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_activities do |t|
      t.string :nombre

      t.datetime "created_at", null: false
    end
    add_index :legacy_activities, :nombre
  end
end
