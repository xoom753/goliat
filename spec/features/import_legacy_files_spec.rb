require "rails_helper"

RSpec.describe "Import legacy files", type: :feature do
  def create_import_file(filename:, year:, status: :uploaded, parser: nil)
    LegacyImportFile.create!(
      filename: filename,
      filepath: "/imports/#{filename}",
      last_modified_at: "1700000000000",
      weight: "1024",
      year: year,
      month: 3,
      status: status,
      parseable: parser
    )
  end

  it "lists uploaded files with parser, status, and parse/ignore actions" do
    parser = LegacyFilesParser.create!(parser_name: "People spreadsheet")
    import_file = create_import_file(filename: "people.xlsx", year: 2024, parser: parser)

    visit import_legacy_files_path

    expect(page).to have_content("Importar archivos")
    expect(page).to have_content("people.xlsx")
    expect(page).to have_content("uploaded")
    expect(page).to have_content("People spreadsheet")
    expect(page).to have_link("Parse", href: parse_import_legacy_files_path(id: import_file.id))
    expect(page).to have_link("Ignore", href: ignore_file_import_legacy_files_path(id: import_file.id))
  end

  it "filters files by filename query, year, and por_importar status" do
    upload_parser = LegacyFilesParser.create!(parser_name: "Upload parser")
    uploaded_match = create_import_file(filename: "cultural_2024.xlsx", year: 2024, parser: upload_parser)
    create_import_file(filename: "deportivo_2023.xlsx", year: 2023)
    create_import_file(filename: "cultural_imported_2024.xlsx", year: 2024, status: :imported)

    visit import_legacy_files_path(q: "cultural", year: "2024", status: "por_importar")

    expect(page).to have_content("cultural_2024.xlsx")
    expect(page).not_to have_content("deportivo_2023.xlsx")
    expect(page).not_to have_content("cultural_imported_2024.xlsx")
    expect(page).to have_link("Parse", href: parse_import_legacy_files_path(id: uploaded_match.id))
    expect(page).to have_link("Por importar")
  end

  it "shows the parser form and configured options for an assigned course parser" do
    parser = LegacyCourseFileParser.create!(parser_name: "Course parser", skip_rows: 1, nombres_col: 0, file_format: "xlsx")
    import_file = create_import_file(filename: "courses.xlsx", year: 2024, parser: parser)

    allow_any_instance_of(LegacyCourseFileParserService).to receive(:parse!).and_return(nil)
    allow_any_instance_of(LegacyCourseFileParserService).to receive(:headers).and_return([["Names"]])
    allow_any_instance_of(LegacyCourseFileParserService).to receive(:records).and_return([])

    visit parse_import_legacy_files_path(id: import_file.id)

    expect(page).to have_content("courses.xlsx")
    expect(page).to have_content("Course parser")
    expect(page).to have_content("Grupo")
    expect(page).to have_content("Actividad")
    expect(page).to have_content("Names")
    expect(page).to have_button("Import records")
  end
end
