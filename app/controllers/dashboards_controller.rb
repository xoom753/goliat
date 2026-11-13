class DashboardsController < ApplicationController
    def people
        if params[:person_id].present?
            @people = Person.where(id: params[:person_id])
        else
            @people = Person.all
        end

        @search_query = params[:s]

        @activity_groups = ActivityGroup.where(
            nombre: [
                "Eje Cultural",
                "Eje Deportivo",
                "Eje Laboral"
            ]
        )

        if @search_query.present? && @search_query.length > 2
            search = "'%#{@search_query}%'"
            @people = @people.where("nombres LIKE #{search} OR dni LIKE #{search}")
        end

        if params[:person_id].present?
            # ui tweak for search input
            @search_query = @people.first.try(:nombres)
        end
        @people = @people.page(params[:page]).per(8)
    end
end
