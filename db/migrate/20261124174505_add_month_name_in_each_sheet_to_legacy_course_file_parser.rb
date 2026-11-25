class AddMonthNameInEachSheetToLegacyCourseFileParser < ActiveRecord::Migration[8.1]
  def change
    add_column :legacy_course_file_parsers, :month_name_in_each_sheet, :boolean
  end
end
