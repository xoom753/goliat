class LegacyCourseFileParsersController < ApplicationController
  before_action :set_legacy_course_file_parser, only: %i[ show edit update destroy ]

  # GET /legacy_course_file_parsers or /legacy_course_file_parsers.json
  def index
    @legacy_course_file_parsers = LegacyCourseFileParser.all
  end

  # GET /legacy_course_file_parsers/1 or /legacy_course_file_parsers/1.json
  def show
  end

  # GET /legacy_course_file_parsers/new
  def new
    @legacy_course_file_parser = LegacyCourseFileParser.new
  end

  # GET /legacy_course_file_parsers/1/edit
  def edit
  end

  # POST /legacy_course_file_parsers or /legacy_course_file_parsers.json
  def create
    @legacy_course_file_parser = LegacyCourseFileParser.new(legacy_course_file_parser_params)

    respond_to do |format|
      if @legacy_course_file_parser.save
        format.html { redirect_to @legacy_course_file_parser, notice: "Legacy course file parser was successfully created." }
        format.json { render :show, status: :created, location: @legacy_course_file_parser }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @legacy_course_file_parser.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /legacy_course_file_parsers/1 or /legacy_course_file_parsers/1.json
  def update
    respond_to do |format|
      if @legacy_course_file_parser.update(legacy_course_file_parser_params)
        format.html { redirect_to @legacy_course_file_parser, notice: "Legacy course file parser was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @legacy_course_file_parser }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @legacy_course_file_parser.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /legacy_course_file_parsers/1 or /legacy_course_file_parsers/1.json
  def destroy
    @legacy_course_file_parser.destroy!

    respond_to do |format|
      format.html { redirect_to legacy_course_file_parsers_path, notice: "Legacy course file parser was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_legacy_course_file_parser
      @legacy_course_file_parser = LegacyCourseFileParser.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def legacy_course_file_parser_params
      params.expect(legacy_course_file_parser: [ :parser_name, :description, :skip_rows, :nombres_col, :fechas_cols, :file_format, :sheet_numbers ])
    end
end
