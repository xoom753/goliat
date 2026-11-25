class LegacyCourseFileParserService
    attr_reader :records, :headers, :ignored_rows, :sheets

    def initialize(legacy_import_file, params:)
        @params = params
        @legacy_import_file = legacy_import_file
        @legacy_course_file_parser = @legacy_import_file.parseable
    end

    def parse!
        @records = []
        @headers = []
        @ignored_rows = []
        @sheets = xlsx.sheets
        if @legacy_course_file_parser.sheet_numbers.present?
            @legacy_course_file_parser.sheet_numbers.split(",").each do |num|
                get_and_parse_sheet!(num.to_i)
            end
        else
            get_and_parse_sheet!(0) # first sheet
        end
    end

    def import_records!
        records.each do |record|
            record.save!
        end
        @legacy_import_file.update!(
            status: :imported,
            records_count: records.count,
            records_list: nil # records.map(&:id).join(",")
        )
    end

    private

    def get_and_parse_sheet!(index)
        parse_sheet!(
            current_sheet: xlsx.sheet(index),
            sheet_name: xlsx.sheets[index]
        )
    end

    def parse_sheet!(current_sheet:, sheet_name:)
        reached_footer = false
        footer_rows_count = 0
        current_row_n = -1 # will skip headers
        current_sheet.each do |row|
            current_row_n += 1
            if skipping_footer? && reached_footer
                break
            elsif current_row_n < @legacy_course_file_parser.skip_rows
                @headers << row
            elsif ignore_specific_row?(row)
                puts current_row_n
                @ignored_rows << row
            elsif row[@legacy_course_file_parser.nombres_col].present?
                @records << build_legacy_person_activity(
                    row: row,
                    current_row_n: current_row_n,
                    sheet_name: sheet_name
                )
            else
                footer_rows_count += 1
                reached_footer = true if footer_rows_count > @legacy_course_file_parser.emtpy_rows_for_footer_count.to_i
            end
        end
    end

    def build_legacy_person_activity(row:, current_row_n:, sheet_name:)
        ::LegacyCourseFileParserService::LegacyPersonActivityBuilder.new(
            row: row,
            params: @params,
            sheet_name: sheet_name,
            current_row_n: current_row_n,
            legacy_import_file: @legacy_import_file,
            legacy_course_file_parser: @legacy_course_file_parser
        ).build_legacy_person_activity
    end

    def ignore_specific_row?(row)
        nombres_str = row[@legacy_course_file_parser.nombres_col].to_s.strip.downcase
        if @legacy_course_file_parser.ignore_specific_rows.present?
            puts nombres_str.squeeze.strip
            @legacy_course_file_parser.ignore_specific_rows_array.map(&:downcase).include?(
                nombres_str.squeeze.strip
            )
        end
    end

    def skipping_footer?
        true
    end

    def xlsx
        @xlsx ||= Roo::Spreadsheet.open(
            file_path,
            extension: @legacy_course_file_parser.file_format.to_sym
        )
    end

    def file_path
        ActiveStorage::Blob.service.path_for(
            @legacy_import_file.file.attachment.blob.key
        )
    end
end
