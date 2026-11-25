class LegacyCourseFileParserService::LegacyPersonActivityBuilder
    MESES = Rails.application.config_for(:meses_list)[:meses].freeze

    delegate :month_name_in_each_sheet?,
             to: :@legacy_course_file_parser

    def initialize(
            row:,
            params:,
            sheet_name:,
            current_row_n:,
            legacy_import_file:,
            legacy_course_file_parser:
        )
        @row = row
        @params = params
        @sheet_name = sheet_name
        @current_row_n = current_row_n
        @legacy_import_file = legacy_import_file
        @legacy_course_file_parser = legacy_course_file_parser
    end

    def build_legacy_person_activity
        activity_group_str = @params[:grupo].to_s.strip.titleize
        activity_str = @params[:actividad].to_s.strip.titleize
        legacy_person_activity = LegacyPersonActivity.new(
            row_number: @current_row_n + 1,
            nombres_str: get_nombres_str,
            activity_group_str: activity_group_str,
            activity_str: activity_str,
            activity_dates: get_activity_dates,
            duracion: @params[:duracion],
            start_date: get_start_date,
            end_date: get_end_date,
            legacy_import_file_id: @legacy_import_file.id
        )
        if @params[:detalle].present?
            legacy_person_activity.activity_detail_str = @params[:detalle].strip.titleize
        end
        legacy_person_activity
    end

    private

    def get_nombres_str
        nombres_str = @row[@legacy_course_file_parser.nombres_col].strip.titleize
        nombres_str.sub("(Ingresa)", "").strip
    end

    def get_activity_dates
        if @params[:rango].present?
            return @params[:rango].to_s.strip.titleize
        end
        if month_name_in_each_sheet?
            return @sheet_name.titleize
        end
    end

    def get_start_date
        if @params[:desde].present?
            return @params[:desde]
        end
        if month_name_in_each_sheet?
            return current_date
        end
    end

    def get_end_date
        if @params[:hasta].present?
            return @params[:hasta]
        end
        if month_name_in_each_sheet?
            return current_date.end_of_month
        end
    end

    def current_date
        return @current_date if @current_date

        month_h = MESES.find do |mes_h|
            (@sheet_name =~ /#{mes_h[:nombre]}/i) || (
                mes_h[:matches].present? && mes_h[:matches].any? do |match|
                    @sheet_name =~ /#{match}/i
                end
            )
        end
        curr_month = MESES.index(month_h) + 1 # because its zero based

        year_str = @sheet_name.sub("G1", "")
        year_str = year_str.sub("G2", "")
        year_str = year_str.downcase.sub(month_h[:nombre], "")

        if month_h[:matches].present?
            month_h[:matches].each do |match|
                year_str = year_str.sub(match, "")
            end
        end

        year = year_str.to_i

        @current_date = Date.new(year, curr_month, 1)
        @current_date
    end
end
