require "test_helper"

class LegacyFilesParsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @legacy_files_parser = legacy_files_parsers(:one)
  end

  test "should get index" do
    get legacy_files_parsers_url
    assert_response :success
  end

  test "should get new" do
    get new_legacy_files_parser_url
    assert_response :success
  end

  test "should create legacy_files_parser" do
    assert_difference("LegacyFilesParser.count") do
      post legacy_files_parsers_url, params: { legacy_files_parser: { activity_dates: @legacy_files_parser.activity_dates, activity_group_str: @legacy_files_parser.activity_group_str, activity_str: @legacy_files_parser.activity_str, duracion: @legacy_files_parser.duracion, end_date_index_from: @legacy_files_parser.end_date_index_from, end_date_index_to: @legacy_files_parser.end_date_index_to, nombres: @legacy_files_parser.nombres, parser_name: @legacy_files_parser.parser_name, row_number: @legacy_files_parser.row_number, sheet_name: @legacy_files_parser.sheet_name, start_date_index_from: @legacy_files_parser.start_date_index_from, start_date_index_to: @legacy_files_parser.start_date_index_to } }
    end

    assert_redirected_to legacy_files_parser_url(LegacyFilesParser.last)
  end

  test "should show legacy_files_parser" do
    get legacy_files_parser_url(@legacy_files_parser)
    assert_response :success
  end

  test "should get edit" do
    get edit_legacy_files_parser_url(@legacy_files_parser)
    assert_response :success
  end

  test "should update legacy_files_parser" do
    patch legacy_files_parser_url(@legacy_files_parser), params: { legacy_files_parser: { activity_dates: @legacy_files_parser.activity_dates, activity_group_str: @legacy_files_parser.activity_group_str, activity_str: @legacy_files_parser.activity_str, duracion: @legacy_files_parser.duracion, end_date_index_from: @legacy_files_parser.end_date_index_from, end_date_index_to: @legacy_files_parser.end_date_index_to, nombres: @legacy_files_parser.nombres, parser_name: @legacy_files_parser.parser_name, row_number: @legacy_files_parser.row_number, sheet_name: @legacy_files_parser.sheet_name, start_date_index_from: @legacy_files_parser.start_date_index_from, start_date_index_to: @legacy_files_parser.start_date_index_to } }
    assert_redirected_to legacy_files_parser_url(@legacy_files_parser)
  end

  test "should destroy legacy_files_parser" do
    assert_difference("LegacyFilesParser.count", -1) do
      delete legacy_files_parser_url(@legacy_files_parser)
    end

    assert_redirected_to legacy_files_parsers_url
  end
end
