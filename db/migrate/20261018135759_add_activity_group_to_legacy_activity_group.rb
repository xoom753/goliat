class AddActivityGroupToLegacyActivityGroup < ActiveRecord::Migration[8.1]
  def change
    add_reference :legacy_activity_groups, :activity_group, null: true, foreign_key: true
  end
end
