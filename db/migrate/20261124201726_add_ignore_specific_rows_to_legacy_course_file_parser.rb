class AddIgnoreSpecificRowsToLegacyCourseFileParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_course_file_parsers, :ignore_specific_rows, :text
  end
end
