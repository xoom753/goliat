class OriginPeopleController < ApplicationController
    def index
        @origin_people = OriginPerson.all
        if params[:s].present? && params[:s].length > 2
            search = "%#{params[:s]}%"
            @origin_people = @origin_people.where(
                "fullname ILIKE :search OR dni LIKE :search",
                search: search
            )
        end
        if params[:proceso_num].present? && params[:proceso_num].length > 2
            @origin_people = @origin_people.where(
                origin_person_legal_processes: OriginPersonLegalProcess.where(
                    "proceso_num LIKE ?",
                    "%#{params[:proceso_num]}%"
                )
            )
        end
        if params[:situacion_actual].present?
            @origin_people = @origin_people.where(
                situacion_actual: params[:situacion_actual]
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
        min_date = Date.today - 1.year
        if params[:sort_by] == "sesenta"
            @origin_person_legal_penalties =
                OriginPersonLegalPenalty.porcentage_present_and_recent("sesenta_porciento_at")
        elsif params[:sort_by] == "cuarenta"
            @origin_person_legal_penalties =
                OriginPersonLegalPenalty.porcentage_present_and_recent("cuarenta_porciento_at")
        end
        @origin_person_legal_penalties =
                @origin_person_legal_penalties.page(params[:page]).per(5)
    end
end
