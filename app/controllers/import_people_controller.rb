class ImportPeopleController < ApplicationController
    def create
        people = params[:people].split("\n")
        people.each do |person|
            pabellon, nombres, dni = person.split("\t")
            Person.create!(
                pabellon: pabellon,
                nombres: nombres,
                dni: dni
            )
        end
        redirect_to action: :new, notice: "Imported #{people.count} people!"
    end
end
