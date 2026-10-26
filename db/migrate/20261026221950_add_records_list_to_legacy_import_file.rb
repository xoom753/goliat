class AddRecordsListToLegacyImportFile < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_import_files, :records_list, :text
  end
end
