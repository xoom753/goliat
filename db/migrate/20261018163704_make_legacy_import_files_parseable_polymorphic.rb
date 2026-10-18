class MakeLegacyImportFilesParseablePolymorphic < ActiveRecord::Migration[8.1]
  def change
    change_table :legacy_import_files do |t|
      t.rename :legacy_files_parser_id, :parseable_id
      t.string :parseable_type
    end
  end
end
