class AddLegacyActivityIdToLegacyPersonActivity < ActiveRecord::Migration[8.1]
  def change
    add_reference :legacy_person_activities, :legacy_activity_detail, null: true, foreign_key: true
  end
end
