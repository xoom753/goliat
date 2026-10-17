class LegacyPersonActivityBelongsToLegacyGroupsAndActivities < ActiveRecord::Migration[8.1]
  def change
    change_table :legacy_person_activities do |t|
      t.references :legacy_activity, null: true, foreign_key: true
      t.references :legacy_activity_group, null: true, foreign_key: true
    end
  end
end
