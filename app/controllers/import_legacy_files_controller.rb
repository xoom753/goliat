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
        if @legacy_import_file.legacy_files_parser.present?
            @legacy_person_activities = ::LegacyFileParseService.new(
                @legacy_import_file
            ).records
        end
    end

    def update_parser
        @legacy_import_file = LegacyImportFile.find params[:id]
        @legacy_import_file.update!(
            legacy_files_parser_id: params.require(:legacy_files_parser_id)
        )
        redirect_to action: :parse, id: params[:id]
    end

    def import_records
        @legacy_import_file = LegacyImportFile.find params[:id]
        ::LegacyFileParseService.new(
            @legacy_import_file
        ).import_records!
        redirect_to action: :show
    end
end
