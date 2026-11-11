namespace :extranjeros_presentes do
    task import_from_xls: :environment do
        file = "Extranjeros presentes.xlsx"
        xlsx = Roo::Spreadsheet.open(file, extension: :xlsx)
        sheet = xlsx.sheet(0)

        row_number = 0
        sheet.each do |row|
            if row_number < 1
                # skipping first row
            else
                nombres = row[0]
                pasaporte = row[2]
                extranjero = ExtranjeroPresente.create!(
                    nombres_str: nombres,
                    pasaporte: pasaporte
                )
                puts "importado: " + extranjero.nombres
            end
            row_number += 1
        end
    end
end
