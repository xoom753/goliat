class PersonPabellonUpdatesController < ApplicationController
    def index
    end

    def create
        people = params[:updates].split("\n")
        people.each do |person|
            nombres, pabellon = person.split("\t")
            PersonPabellonUpdate.create!(
                nombres: nombres,
                pabellon: pabellon
            )
        end
        redirect_to action: :new, notice: "Imported #{people.count} updates!"
    end

    def update
        person_pabellon_update = PersonPabellonUpdate.find(params[:id])
        person_pabellon_update.update!(nombres: params.require(:nombres))
        head :ok
    end
end
