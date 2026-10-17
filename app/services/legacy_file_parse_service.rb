class LegacyFileParseService
    delegate :start_date_index_from,
             :start_date_index_to,
             :end_date_index_from,
             :end_date_index_to,
             to: :@legacy_files_parser

    def initialize(legacy_import_file)
        @legacy_import_file = legacy_import_file
        @legacy_files_parser = @legacy_import_file.legacy_files_parser
    end

    def records
        activities = []
        parsing_first_row = true
        sheet.each(
            row_number: @legacy_files_parser.row_number,
            nombres: @legacy_files_parser.nombres,
            servicios: @legacy_files_parser.activity_group_str,
            actividad: @legacy_files_parser.activity_str,
            fecha: @legacy_files_parser.activity_dates,
            duracion: @legacy_files_parser.duracion
        ) do |hash|
            if parsing_first_row
                parsing_first_row = false
            elsif hash[:nombres].present?
                activity_dates = hash[:fecha].strip
                activities << legacy_person_activity = LegacyPersonActivity.new(
                    row_number: hash[:row_number],
                    nombres_str: hash[:nombres].strip,
                    activity_group_str: hash[:servicios],
                    activity_str: hash[:actividad],
                    activity_dates: activity_dates,
                    duracion: hash[:duracion],
                    start_date: activity_dates[start_date_index_from, start_date_index_to],
                    end_date: activity_dates[end_date_index_from, end_date_index_to]
                )
            end
        end
        activities
    end

    def import_records!
        records.each do |record|
            record.save!
        end
        @legacy_import_file.update!(status: :imported)
    end

    private

    def sheet
        file_path = ActiveStorage::Blob.service.path_for(
            @legacy_import_file.file.attachment.blob.key
        )
        xlsx = Roo::Spreadsheet.open(file_path, extension: @legacy_files_parser.file_format.to_sym)
        xlsx.sheet(@legacy_files_parser.sheet_name)
    end
end
