class LegacyPersonActivitiesController < ApplicationController
    def index
        @legacy_person_activities = LegacyPersonActivity.all.page(params[:page]).per(100)
    end
end
