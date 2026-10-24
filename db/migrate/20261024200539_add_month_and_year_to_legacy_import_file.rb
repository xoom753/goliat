class AddMonthAndYearToLegacyImportFile < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_import_files, :year, :integer
    add_column :legacy_import_files, :month, :integer
    add_index :legacy_import_files, [:year, :month]
  end
end
