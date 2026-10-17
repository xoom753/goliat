class CreateLegacyActivityGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_activity_groups do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
