class CreateNewPeopleTask
  def call
    created_count = 0

    PersonPabellonUpdate.find_each do |update|
      sanitized_name = update.nombres.split(" ").join(" ")
      origin_person = OriginPerson.find_by(fullname: sanitized_name)
      if origin_person.present?
        Person.create!(
          estado: :presente,
          dni: origin_person.dni,
          nombres: sanitized_name,
          pabellon: update.pabellon
        )
        update.destroy
        puts "Created #{sanitized_name}"
        created_count += 1
      else
        puts "Not found #{sanitized_name}"
      end
    end

    puts "created #{created_count} people"
    created_count
  end
end
