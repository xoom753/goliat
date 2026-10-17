class LegacyPersonActivityBelongsToLegacyPerson < ActiveRecord::Migration[8.1]
  def change
    change_table :legacy_person_activities do |t|
      t.references :legacy_person, null: true, foreign_key: true
    end
  end
end
