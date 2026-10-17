class CreateActivityGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_groups do |t|
      t.string :nombre, null: false

      # t.timestamps
    end
  end
end
