class DashboardsController < ApplicationController
    def people
        @activity_groups = ActivityGroup.all
        @people = Person.all
        if params[:s].present? && params[:s].length > 2
            search = "'%#{params[:s]}%'"
            @people = @people.where("nombres LIKE #{search} OR dni LIKE #{search}")
        end
        @people = @people.page(params[:page]).per(10)
    end
end
