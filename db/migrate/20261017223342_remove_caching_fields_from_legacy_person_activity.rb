class RemoveCachingFieldsFromLegacyPersonActivity < ActiveRecord::Migration[8.1]
  def change
    remove_column :legacy_person_activities, :nombres, :string
    remove_column :legacy_person_activities, :activity_group_str, :string
    remove_column :legacy_person_activities, :activity_str, :string
  end
end
