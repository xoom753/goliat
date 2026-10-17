class CreateLegacyFilesParsers < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_files_parsers do |t|
      t.string :parser_name
      t.string :row_number
      t.string :nombres
      t.string :activity_group_str
      t.string :activity_str
      t.string :activity_dates
      t.string :duracion
      t.integer :start_date_index_from
      t.integer :start_date_index_to
      t.integer :end_date_index_from
      t.integer :end_date_index_to
      t.string :sheet_name

      t.timestamps
    end
  end
end
