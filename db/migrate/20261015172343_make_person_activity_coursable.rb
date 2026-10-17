class MakePersonActivityCoursable < ActiveRecord::Migration[8.1]
  def change
    change_table :person_activities do |t|
      t.rename :activity_id, :coursable_id
      t.string :coursable_type
    end
    add_index :person_activities, [:coursable_type, :coursable_id]
  end
end
