class LegacyActivitiesController < ApplicationController
    def index
        @legacy_activities = LegacyActivity.all

        if params[:s].present? && params[:s].length > 2
            search = "'%#{params[:s].strip}%'"
            @legacy_activities = @legacy_activities.where("nombre LIKE #{search}")
        end

        @legacy_activities = @legacy_activities.ordered.page(params[:page]).per(50)
    end
end
