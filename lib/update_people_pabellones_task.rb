class UpdatePeoplePabellonesTask
  def call
    updated_count = 0

    PersonPabellonUpdate.find_each do |update|
      person = Person.find_by(nombres: update.nombres.strip)
      if person.present?
        person.update!(
          estado: :presente,
          pabellon: update.pabellon,
          celda: update.celda
        )
        updated_count += 1
        update.destroy
      else
        puts "Not found #{update.nombres} - #{update.pabellon}"
      end
    end

    puts "updated correctly #{updated_count} people"
    updated_count
  end
end
