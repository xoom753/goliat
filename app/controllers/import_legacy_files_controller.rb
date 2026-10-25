class ImportLegacyFilesController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:create]

    def show
        scope = LegacyImportFile.sorted_by_date
        if params[:q].present?
            query = "%#{params[:q]}%"
            scope = scope.where(
                "filename LIKE '#{query}'"
            )
        end
        if params[:year].present?
            scope = scope.where(year: params[:year])
        end
        @legacy_import_files =
            scope.page(params[:page])
                 .per(100)
    end

    def create
        LegacyImportFile.create!(
            file: params.require(:file),
            last_modified_at: params.require(:last_modified_at),
            filename: params.require(:filename),
            filepath: params.require(:origin_filepath),
            weight: params.require(:filesize)
        )
        redirect_to action: :show
    end

    def parse
        @legacy_import_file = LegacyImportFile.find params[:id]
        if @legacy_import_file.parseable.present? && @legacy_import_file.parseable.is_a?(LegacyFilesParser)
            @legacy_person_activities = ::LegacyFileParseService.new(
                @legacy_import_file
            ).records
        elsif @legacy_import_file.parseable.present? && @legacy_import_file.parseable.is_a?(LegacyCourseFileParser)
            parser_service = ::LegacyCourseFileParserService.new(
                @legacy_import_file,
                params: params
            )
            parser_service.parse!
            @file_headers = parser_service.headers
            @legacy_person_activities = parser_service.records
        end
    end

    def update_parser
        @legacy_import_file = LegacyImportFile.find params[:id]
        parseable_id, parseable_type = params.require(:parseable_id_and_type).split("_")
        @legacy_import_file.update!(
            parseable_id: parseable_id,
            parseable_type: parseable_type
        )
        redirect_to action: :parse, id: params[:id]
    end

    def import_records
        @legacy_import_file = LegacyImportFile.find params[:id]
        if @legacy_import_file.parseable.present? && @legacy_import_file.parseable.is_a?(LegacyFilesParser)
            ::LegacyFileParseService.new(
                @legacy_import_file
            ).import_records!
        elsif @legacy_import_file.parseable.present? && @legacy_import_file.parseable.is_a?(LegacyCourseFileParser)
            parser_service = ::LegacyCourseFileParserService.new(
                @legacy_import_file,
                params: params
            )
            parser_service.parse!
            parser_service.import_records!
        end
        redirect_to action: :show
    end

    def ignore_file
        @legacy_import_file = LegacyImportFile.find params[:id]
        @legacy_import_file.update!(status: :ignored)
        redirect_to action: :show
    end

    def remove_file
        @legacy_import_file = LegacyImportFile.find params[:id]
        @legacy_import_file.file.purge
        @legacy_import_file.update!(status: :file_removed)
        redirect_to action: :show
    end

    def update_dates
        @legacy_import_file = LegacyImportFile.find params[:id]
        @legacy_import_file.update!(
            year: params[:year],
            month: params[:month]
        )
        redirect_to action: :show
    end
end
