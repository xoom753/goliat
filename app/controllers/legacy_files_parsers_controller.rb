class LegacyFilesParsersController < ApplicationController
  before_action :set_legacy_files_parser, only: %i[ show edit update destroy ]

  # GET /legacy_files_parsers or /legacy_files_parsers.json
  def index
    @legacy_files_parsers = LegacyFilesParser.all
  end

  # GET /legacy_files_parsers/1 or /legacy_files_parsers/1.json
  def show
  end

  # GET /legacy_files_parsers/new
  def new
    @legacy_files_parser = LegacyFilesParser.new
  end

  # GET /legacy_files_parsers/1/edit
  def edit
  end

  # POST /legacy_files_parsers or /legacy_files_parsers.json
  def create
    @legacy_files_parser = LegacyFilesParser.new(legacy_files_parser_params)

    respond_to do |format|
      if @legacy_files_parser.save
        format.html { redirect_to @legacy_files_parser, notice: "Legacy files parser was successfully created." }
        format.json { render :show, status: :created, location: @legacy_files_parser }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @legacy_files_parser.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /legacy_files_parsers/1 or /legacy_files_parsers/1.json
  def update
    respond_to do |format|
      if @legacy_files_parser.update(legacy_files_parser_params)
        format.html { redirect_to @legacy_files_parser, notice: "Legacy files parser was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @legacy_files_parser }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @legacy_files_parser.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /legacy_files_parsers/1 or /legacy_files_parsers/1.json
  def destroy
    @legacy_files_parser.destroy!

    respond_to do |format|
      format.html { redirect_to legacy_files_parsers_path, notice: "Legacy files parser was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_legacy_files_parser
      @legacy_files_parser = LegacyFilesParser.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def legacy_files_parser_params
      params.expect(legacy_files_parser: [ :parser_name, :row_number, :nombres, :activity_group_str, :activity_str, :activity_dates, :duracion, :start_date_index_from, :start_date_index_to, :end_date_index_from, :end_date_index_to, :sheet_name, :file_format ])
    end
end
