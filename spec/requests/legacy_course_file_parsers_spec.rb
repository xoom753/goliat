require "rails_helper"

RSpec.describe "Legacy course file parsers", type: :request do
  it "renders the HTML collection and editor pages" do
    parser = LegacyCourseFileParser.create!(parser_name: "Course workbook")

    get legacy_course_file_parsers_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Course workbook")

    get new_legacy_course_file_parser_path
    expect(response).to have_http_status(:ok)

    get legacy_course_file_parser_path(parser)
    expect(response).to have_http_status(:ok)

    get edit_legacy_course_file_parser_path(parser)
    expect(response).to have_http_status(:ok)
  end

  it "renders the edit form when an update is invalid" do
    parser = LegacyCourseFileParser.create!(parser_name: "Course workbook")

    patch legacy_course_file_parser_path(parser, format: :json), params: {
      legacy_course_file_parser: { parser_name: nil }
    }

    expect(response).to have_http_status(:unprocessable_content)
    expect(parser.reload.parser_name).to eq("Course workbook")
  end

  it "creates, updates, and deletes a parser through the JSON API" do
    post legacy_course_file_parsers_path(format: :json), params: {
      legacy_course_file_parser: {
        parser_name: "Course workbook",
        description: "Test parser",
        skip_rows: 1,
        nombres_col: 0,
        fechas_cols: "A:B",
        file_format: "xlsx",
        sheet_numbers: "0,1"
      }
    }

    expect(response).to have_http_status(:created)
    parser = LegacyCourseFileParser.last
    expect(parser.parser_name).to eq("Course workbook")

    patch legacy_course_file_parser_path(parser, format: :json), params: {
      legacy_course_file_parser: { parser_name: "Updated course workbook" }
    }

    expect(response).to have_http_status(:ok)
    expect(parser.reload.parser_name).to eq("Updated course workbook")

    delete legacy_course_file_parser_path(parser, format: :json)

    expect(response).to have_http_status(:no_content)
    expect(LegacyCourseFileParser.exists?(parser.id)).to be(false)
  end

  it "returns validation errors when parser creation is invalid" do
    post legacy_course_file_parsers_path(format: :json), params: {
      legacy_course_file_parser: { parser_name: nil }
    }

    expect(response).to have_http_status(:unprocessable_content)
  end
end
