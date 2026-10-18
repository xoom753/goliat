class CreateLegacyCourseFileParsers < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_course_file_parsers do |t|
      t.string :parser_name, null: false
      t.text :description
      t.integer :skip_rows
      t.integer :nombres_col
      t.string :fechas_cols
      t.string :file_format

      t.timestamps
    end
  end
end
