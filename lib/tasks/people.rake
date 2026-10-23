namespace :people do
    task update_pabellones: :environment do
        updated_correctly = 0
        puts "WARN setting all people as :indefinido"
        Person.update_all(
            estado: 2
        )
        PersonPabellonUpdate.find_each do |update|
            existing = Person.find_by(nombres: update.nombres.strip)
            if existing.present?
                existing.update!(
                    estado: :presente,
                    pabellon: update.pabellon
                )
                updated_correctly += 1
                update.destroy
            else
                puts "Not found #{update.nombres} - #{update.pabellon}"
            end
        end

        puts "updated correctly #{updated_correctly} people"
    end

    desc "Look for new people and create them"
    task create_new_people: :environment do
        created_count = 0
        PersonPabellonUpdate.find_each do |update|
            origin_person = OriginPerson.find_by(
                fullname: update.nombres
            )
            if origin_person.present?
                Person.create!(
                    estado: :presente,
                    dni: origin_person.dni,
                    nombres: update.nombres,
                    pabellon: update.pabellon
                )
                update.destroy
                puts "Created #{update.nombres}"
                created_count += 1
            else
                puts "Not found #{update.nombres}"
            end
        end
        puts "created #{created_count} people"
    end
end
