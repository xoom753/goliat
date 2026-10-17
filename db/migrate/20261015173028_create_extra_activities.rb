class CreateExtraActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :extra_activities do |t|
      t.string :nombre, null: false

      t.datetime "created_at", null: false
    end
  end
end
