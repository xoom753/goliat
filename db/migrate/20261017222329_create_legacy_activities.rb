class CreateLegacyActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_activities do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
