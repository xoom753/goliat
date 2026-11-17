require "import_bateria_indicadores_task"

namespace :origin_people do
    task import_origin_people: :environment do
        filename = "bateria-indicadores-13-nov-2026.xlsx"
        xlsx = Roo::Spreadsheet.open(filename, extension: :xlsx)
        ImportBateriaIndicadoresTask.new(xlsx).import!
    end
end
