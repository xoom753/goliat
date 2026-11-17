class DashboardsController < ApplicationController
    def people
        if params[:person_id].present?
            @people = Person.where(id: params[:person_id])
        else
            @people = Person.all
        end

        if params[:estado].present?
            @people = @people.where(estado: params[:estado])
        end

        generic_people
    end

    def people_presente
        @people = Person.where(estado: :presente)
        generic_people
        render :people
    end

    private

    def generic_people
        @activity_groups = ActivityGroup.where(
            nombre: [
                "Eje Cultural",
                "Eje Deportivo",
                "Eje Laboral"
            ]
        )

        @search_query = params[:s]

        if @search_query.present? && @search_query.length > 2
            @people = @people.where(
                "nombres ILIKE :search OR dni LIKE :search",
                search: "%#{@search_query}%"
            )
        end

        if params[:person_id].present?
            # ui tweak for search input
            @search_query = @people.first.try(:nombres)
        end
        @people = @people.page(params[:page]).per(8)
    end
end
