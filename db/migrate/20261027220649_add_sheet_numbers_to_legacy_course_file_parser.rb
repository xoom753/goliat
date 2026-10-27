class AddSheetNumbersToLegacyCourseFileParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_course_file_parsers, :sheet_numbers, :string
  end
end
