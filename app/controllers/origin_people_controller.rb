class OriginPeopleController < ApplicationController
    def index
        @origin_people = OriginPerson.all
        if params[:s].present? && params[:s].length > 2
            search = "'%#{params[:s]}%'"
            @origin_people = @origin_people.where("fullname LIKE #{search} OR dni LIKE #{search}")
        end
        if params[:proceso_num].present? && params[:proceso_num].length > 2
            proceso_num_search = "'%#{params[:proceso_num]}%'"
            @origin_people = @origin_people.where(
                origin_person_legal_processes: OriginPersonLegalProcess.where(
                    "proceso_num LIKE #{proceso_num_search}"
                )
            )
        end
        @origin_people =
            @origin_people.includes(
                    origin_person_legal_processes: :origin_person_legal_penalty
                )
                .page(params[:page])
                .per(5)
    end

    def by_percentage
        if params[:sort_by] == "sesenta"
            @origin_person_legal_penalties = OriginPersonLegalPenalty.where(
                "sesenta_porciento_at IS NOT NULL"
            ).order(
                sesenta_porciento_at: :asc
            )

            @origin_person_legal_penalties =
                @origin_person_legal_penalties.page(params[:page]).per(5)
        end
    end
end
