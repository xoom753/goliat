class AddOverrideHastaToLegacyImportFile < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_import_files, :override_hasta, :date
  end
end
