class SecondRemoveForeignKeyForLegacyFileParser < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key "person_activities", "activities", column: "coursable_id"
  end
end
