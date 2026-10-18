class CreateLegacyActivityGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_activity_groups do |t|
      t.string :nombre

      t.datetime "created_at", null: false
    end
    add_index :legacy_activity_groups, :nombre
  end
end
