class AddDefaultGroupToLegacyFilesParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_files_parsers, :default_activity_group_str, :string
  end
end
