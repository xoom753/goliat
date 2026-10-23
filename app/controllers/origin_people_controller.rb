class OriginPeopleController < ApplicationController
    def index
        @origin_people = OriginPerson.all
        if params[:s].present? && params[:s].length > 2
            search = "'%#{params[:s]}%'"
            @origin_people = @origin_people.where("fullname LIKE #{search} OR dni LIKE #{search}")
        end
        @origin_people =
            @origin_people.includes(
                    origin_person_legal_processes: :origin_person_legal_penalty
                )
                .page(params[:page])
                .per(5)
    end
end
