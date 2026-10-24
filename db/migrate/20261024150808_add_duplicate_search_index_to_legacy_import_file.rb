class AddDuplicateSearchIndexToLegacyImportFile < ActiveRecord::Migration[8.1]
  def change
    add_index :legacy_import_files, [
      :filename,
      :last_modified_at,
      :weight,
      :id
    ]
  end
end
