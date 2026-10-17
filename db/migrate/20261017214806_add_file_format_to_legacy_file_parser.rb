class AddFileFormatToLegacyFileParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_files_parsers, :file_format, :string
  end
end
