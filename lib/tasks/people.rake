namespace :people do
    task update_pabellones: :environment do
        updated_correctly = 0
        PersonPabellonUpdate.find_each do |update|
            existing = Person.find_by(nombres: update.nombres.strip)
            if existing.present?
                existing.update!(pabellon: update.pabellon)
                updated_correctly += 1
                update.destroy
            else
                puts "Not found #{update.nombres} - #{update.pabellon}"
            end
        end

        puts "updated correctly #{updated_correctly} people"
    end
end