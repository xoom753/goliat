class LegacyActivitiesController < ApplicationController
    def index
        @legacy_activities = LegacyActivity.all

        if params[:s].present? && params[:s].length > 2
            @legacy_activities = @legacy_activities.where(
                "nombre ILIKE ?",
                "%#{params[:s].strip}%"
            )
        end

        @legacy_activities = @legacy_activities.ordered.page(params[:page]).per(50)
    end
end
