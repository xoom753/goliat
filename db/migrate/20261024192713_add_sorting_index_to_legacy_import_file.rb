class AddSortingIndexToLegacyImportFile < ActiveRecord::Migration[8.1]
  def change
    add_index :legacy_import_files, [:last_modified_at, :filename]
  end
end
