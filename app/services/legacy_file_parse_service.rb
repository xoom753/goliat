class LegacyFileParseService
    delegate :start_date_index_from,
             :start_date_index_to,
             :end_date_index_from,
             :end_date_index_to,
             to: :@legacy_files_parser

    def initialize(legacy_import_file)
        @legacy_import_file = legacy_import_file
        @legacy_files_parser = @legacy_import_file.parseable
    end

    def records
        activities = []
        parsing_first_row = true
        sheet.each(sheet_headers) do |hash|
            if parsing_first_row
                parsing_first_row = false
            elsif hash[:nombres].present?
                activities << build_legacy_person_activity(
                    hash
                )
            end
        end
        activities
    rescue Roo::HeaderRowNotFoundError => e
        puts "\n\n=== ERR:\n\n"
        puts e.inspect
        []
    end

    def import_records!
        records.each do |record|
            record.save!
        end
        @legacy_import_file.update!(
            status: :imported,
            records_count: records.count,
            records_list: nil #records.map(&:id).join(",")
        )
    end

    private

    def build_legacy_person_activity(hash)
        activity_group_str = hash[:servicios].strip.titleize

        ##
        # there's some rows in which :actividad is empty:
        activity_str = if hash[:actividad].blank?
            activity_group_str
        else
            hash[:actividad].strip.titleize
        end

        activity_dates = hash[:fecha].to_s.strip

        ##
        # allow :override_hasta:
        end_date = if @legacy_import_file.override_hasta.present?
            @legacy_import_file.override_hasta
        else
            activity_dates[end_date_index_from, end_date_index_to]
        end

        nombres_str = hash[:nombres].strip.titleize
        activity_detail_str = hash[:activity_detail].presence || ""
        start_date = activity_dates[start_date_index_from, start_date_index_to]

        LegacyPersonActivity.new(
            row_number: hash[:row_number],
            nombres_str: nombres_str,
            activity_group_str: activity_group_str,
            activity_str: activity_str,
            activity_detail_str: activity_detail_str.strip.titleize,
            activity_dates: activity_dates,
            duracion: hash[:duracion].to_s.strip,
            start_date: start_date,
            end_date: end_date,
            legacy_import_file_id: @legacy_import_file.id
        )
    end

    def sheet
        file_path = ActiveStorage::Blob.service.path_for(
            @legacy_import_file.file.attachment.blob.key
        )
        xlsx = Roo::Spreadsheet.open(file_path, extension: @legacy_files_parser.file_format.to_sym)
        xlsx.sheet(@legacy_files_parser.sheet_name)
    end

    def sheet_headers
        headers_row = {
            row_number: @legacy_files_parser.row_number,
            nombres: @legacy_files_parser.nombres,
            servicios: @legacy_files_parser.activity_group_str,
            actividad: @legacy_files_parser.activity_str,
            fecha: @legacy_files_parser.activity_dates,
            duracion: @legacy_files_parser.duracion
        }
        if @legacy_files_parser.activity_detail_str.present?
            headers_row[:activity_detail] = @legacy_files_parser.activity_detail_str
        end
        headers_row
    end
end
