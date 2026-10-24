class ImportLegacyFilesController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:create]

    def show
        @legacy_import_files = LegacyImportFile.all.page(params[:page])
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
end
