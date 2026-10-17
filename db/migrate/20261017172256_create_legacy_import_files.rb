class CreateLegacyImportFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_import_files do |t|
      t.string :filename
      t.string :filepath
      t.string :last_modified_at
      t.references :legacy_files_parser, null: true, foreign_key: true
      t.integer :status, default: 0
      t.integer :duplicate_of_id
      t.string :weight

      t.timestamps
    end
  end
end
