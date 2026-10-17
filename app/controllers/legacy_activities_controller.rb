class LegacyActivitiesController < ApplicationController
    def index
        @legacy_activities = LegacyActivity.all.page(params[:page]).per(100)
    end
end
