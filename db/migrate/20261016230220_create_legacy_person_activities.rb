class CreateLegacyPersonActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_person_activities do |t|
      t.integer :row_number
      t.string :nombres, null: false
      t.string :activity_group_str
      t.string :activity_str
      t.string :activity_dates
      t.string :duracion
      t.date :start_date
      t.date :end_date

      t.datetime "created_at", null: false
    end
  end
end
