require "test_helper"

class LegacyCourseFileParsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @legacy_course_file_parser = legacy_course_file_parsers(:one)
  end

  test "should get index" do
    get legacy_course_file_parsers_url
    assert_response :success
  end

  test "should get new" do
    get new_legacy_course_file_parser_url
    assert_response :success
  end

  test "should create legacy_course_file_parser" do
    assert_difference("LegacyCourseFileParser.count") do
      post legacy_course_file_parsers_url, params: { legacy_course_file_parser: { description: @legacy_course_file_parser.description, fechas_cols: @legacy_course_file_parser.fechas_cols, nombres_col: @legacy_course_file_parser.nombres_col, parser_name: @legacy_course_file_parser.parser_name, skip_rows: @legacy_course_file_parser.skip_rows } }
    end

    assert_redirected_to legacy_course_file_parser_url(LegacyCourseFileParser.last)
  end

  test "should show legacy_course_file_parser" do
    get legacy_course_file_parser_url(@legacy_course_file_parser)
    assert_response :success
  end

  test "should get edit" do
    get edit_legacy_course_file_parser_url(@legacy_course_file_parser)
    assert_response :success
  end

  test "should update legacy_course_file_parser" do
    patch legacy_course_file_parser_url(@legacy_course_file_parser), params: { legacy_course_file_parser: { description: @legacy_course_file_parser.description, fechas_cols: @legacy_course_file_parser.fechas_cols, nombres_col: @legacy_course_file_parser.nombres_col, parser_name: @legacy_course_file_parser.parser_name, skip_rows: @legacy_course_file_parser.skip_rows } }
    assert_redirected_to legacy_course_file_parser_url(@legacy_course_file_parser)
  end

  test "should destroy legacy_course_file_parser" do
    assert_difference("LegacyCourseFileParser.count", -1) do
      delete legacy_course_file_parser_url(@legacy_course_file_parser)
    end

    assert_redirected_to legacy_course_file_parsers_url
  end
end
