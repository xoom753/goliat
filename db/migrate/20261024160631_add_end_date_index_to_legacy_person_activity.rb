class AddEndDateIndexToLegacyPersonActivity < ActiveRecord::Migration[8.1]
  def change
    add_index :legacy_person_activities, :end_date
  end
end
