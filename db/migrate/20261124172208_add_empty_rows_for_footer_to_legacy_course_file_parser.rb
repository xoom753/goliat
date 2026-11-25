class AddEmptyRowsForFooterToLegacyCourseFileParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_course_file_parsers,
               :emtpy_rows_for_footer_count,
               :integer
  end
end
