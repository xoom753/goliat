class PresentesPabellonesController < ApplicationController
    def index
        people = Person.where(
            estado: :presente
        ).order(
            pabellon: :asc,
            celda: :asc,
            nombres: :asc
        )

        if params[:pabellon].present?
            people = people.where(pabellon: params[:pabellon])
        end

        @pabellones_list = Person.where(
            estado: :presente
        ).distinct.pluck(:pabellon).sort

        @people_by_pabellon = people.inject({}) do |memo, person|
            memo[person.pabellon] ||= []
            memo[person.pabellon] << person
            memo
        end
    end
end
