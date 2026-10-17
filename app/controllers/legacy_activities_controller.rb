class LegacyActivitiesController < ApplicationController
    def index
        @legacy_activities = LegacyPersonActivity.all.page(params[:page]).per(100)
    end
end