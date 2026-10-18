class AddActivityDetailStrToLegacyFilesParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_files_parsers, :activity_detail_str, :string
    add_column :legacy_files_parsers, :description, :text
  end
end
