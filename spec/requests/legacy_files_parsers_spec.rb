require "rails_helper"

RSpec.describe "Legacy files parsers", type: :request do
  it "renders the HTML collection and editor pages" do
    parser = LegacyFilesParser.create!(parser_name: "Legacy workbook")

    get legacy_files_parsers_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Legacy workbook")

    get new_legacy_files_parser_path
    expect(response).to have_http_status(:ok)

    get legacy_files_parser_path(parser)
    expect(response).to have_http_status(:ok)

    get edit_legacy_files_parser_path(parser)
    expect(response).to have_http_status(:ok)
  end

  it "creates, updates, and deletes a parser through the JSON API" do
    post legacy_files_parsers_path(format: :json), params: {
      legacy_files_parser: {
        parser_name: "Legacy workbook",
        row_number: "Row",
        nombres: "Name",
        activity_group_str: "Group",
        activity_str: "Activity",
        activity_dates: "Dates",
        duracion: "Duration",
        start_date_index_from: 0,
        start_date_index_to: 10,
        end_date_index_from: 13,
        end_date_index_to: 23,
        sheet_name: "Sheet1",
        file_format: "xlsx",
        description: "Test parser"
      }
    }

    expect(response).to have_http_status(:created)
    parser = LegacyFilesParser.last
    expect(parser.parser_name).to eq("Legacy workbook")

    patch legacy_files_parser_path(parser, format: :json), params: {
      legacy_files_parser: { parser_name: "Updated workbook" }
    }

    expect(response).to have_http_status(:ok)
    expect(parser.reload.parser_name).to eq("Updated workbook")

    delete legacy_files_parser_path(parser, format: :json)

    expect(response).to have_http_status(:no_content)
    expect(LegacyFilesParser.exists?(parser.id)).to be(false)
  end

  it "renders the new form when HTML creation fails" do
    allow_any_instance_of(LegacyFilesParser).to receive(:save).and_return(false)

    post legacy_files_parsers_path, params: { legacy_files_parser: { parser_name: "Parser" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("New legacy files parser")
  end

  it "renders the edit form when an HTML update fails" do
    parser = LegacyFilesParser.create!(parser_name: "Legacy workbook")
    allow_any_instance_of(LegacyFilesParser).to receive(:update).and_return(false)

    patch legacy_files_parser_path(parser), params: {
      legacy_files_parser: { parser_name: "" }
    }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Editing legacy files parser")
  end

  it "returns validation errors when parser creation is invalid" do
    post legacy_files_parsers_path(format: :json), params: { legacy_files_parser: {} }

    expect(response).to have_http_status(:bad_request)
  end
end
