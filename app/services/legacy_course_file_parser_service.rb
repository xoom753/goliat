class LegacyCourseFileParserService
    attr_reader :records, :headers

    def initialize(legacy_import_file, params:)
        @params = params
        @legacy_import_file = legacy_import_file
        @legacy_course_file_parser = @legacy_import_file.parseable
    end

    def parse!
        @records = []
        @headers = []
        if @legacy_course_file_parser.sheet_numbers.present?
            @legacy_course_file_parser.sheet_numbers.split(",").each do |num|
                parse_sheet!(
                    xlsx.sheet(num.to_i)
                )
            end
        else
            parse_sheet!(
                xlsx.sheet(0) # first sheet
            )
        end
    end

    def import_records!
        records.each do |record|
            record.save!
        end
        @legacy_import_file.update!(
            status: :imported,
            records_count: records.count,
            records_list: records.map(&:id).join(",")
        )
    end

    private

    def parse_sheet!(current_sheet)
        reached_footer = false
        current_row_n = -1 # will skip headers
        current_sheet.each do |row|
            current_row_n += 1
            if skipping_footer? && reached_footer
                break
            elsif current_row_n < @legacy_course_file_parser.skip_rows
                @headers << row
            elsif row[@legacy_course_file_parser.nombres_col].present?
                @records << build_legacy_person_activity(
                    row: row,
                    current_row_n: current_row_n
                )
            else
                reached_footer = true
            end
        end
    end

    def build_legacy_person_activity(row:, current_row_n:)
        nombres_str = row[@legacy_course_file_parser.nombres_col].strip.titleize
        activity_group_str = @params[:grupo].to_s.strip.titleize
        activity_str = @params[:actividad].to_s.strip.titleize
        activity_dates = @params[:rango].to_s.strip.titleize
        legacy_person_activity = LegacyPersonActivity.new(
            row_number: current_row_n + 1,
            nombres_str: nombres_str,
            activity_group_str: activity_group_str,
            activity_str: activity_str,
            activity_dates: activity_dates,
            duracion: @params[:duracion],
            end_date: @params[:hasta]
        )
        if @params[:detalle].present?
            legacy_person_activity.activity_detail_str = @params[:detalle].strip.titleize
        end
        legacy_person_activity
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
