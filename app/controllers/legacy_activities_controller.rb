class LegacyActivitiesController < ApplicationController
    def index
        @legacy_activities = LegacyActivity.all.ordered.page(params[:page]).per(200)
    end
end
