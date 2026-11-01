class RemoveForeignKeyForLegacyFileParser < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key "legacy_import_files", "legacy_files_parsers", column: "parseable_id"
  end
end
