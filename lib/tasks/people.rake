namespace :people do
  desc "Update pavilion assignments for existing people"
  task update_pabellones: :environment do
    UpdatePeoplePabellonesTask.new.call
  end

  task mark_all_presentes_as_indefinido: :environment do
    puts "WARN setting all presentes as :indefinido"
    Person.where(estado: :presente).update_all(estado: :indefinido)
  end

  desc "Look for new people and create them"
  task create_new_people: :environment do
    CreateNewPeopleTask.new.call
  end

  task import_listado_pabellones: :environment do
    filename = "LISTADO-PABELLONES-16-11-2026.xlsx"
    xlsx = Roo::Spreadsheet.open(filename, extension: :xlsx)
    ImportListadoPabellonesTask.new(xlsx).import!
  end

  task update_people_without_dni: :environment do
    Person.where(dni: "#N/D").each do |person|
      origin_person = OriginPerson.find_by(fullname: person.nombres)
      if origin_person.present?
        person.update!(
          dni: origin_person.dni
        )
        puts "#{person.nombres} actualizado"
      else
        puts "#{person.nombres} no encontrado"
      end
    end
  end
end
