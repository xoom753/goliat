class DashboardsController < ApplicationController
    def people
        if params[:person_id].present?
            @people = Person.where(id: params[:person_id])
        else
            @people = Person.all
        end

        @activity_groups = ActivityGroup.where(
            nombre: [
                "Eje Cultural",
                "Eje Deportivo",
                "Eje Laboral",
            ]
        )

        if params[:s].present? && params[:s].length > 2
            search = "'%#{params[:s]}%'"
            @people = @people.where("nombres LIKE #{search} OR dni LIKE #{search}")
        end
        @people = @people.page(params[:page]).per(10)
    end
end
