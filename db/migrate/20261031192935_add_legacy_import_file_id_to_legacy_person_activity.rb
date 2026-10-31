class AddLegacyImportFileIdToLegacyPersonActivity < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_person_activities, :legacy_import_file_id, :integer
  end
end
