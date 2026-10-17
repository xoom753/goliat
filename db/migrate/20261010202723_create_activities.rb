class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :activity_group, null: false, foreign_key: true
      t.string :nombre, null: false

      # t.timestamps
    end
  end
end
