require "import_origin_people_task"

namespace :origin_people do
    task import_origin_people: :environment do
        file = "indicadores_presentes_16_oct_fixed.xlsx"
        xlsx = Roo::Spreadsheet.open(file, extension: :xlsx)
        ImportOriginPeopleTask.new(
            xlsx
        ).import!
    end
end
