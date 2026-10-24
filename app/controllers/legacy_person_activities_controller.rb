class LegacyPersonActivitiesController < ApplicationController
    def index
        @legacy_person_activities =
            LegacyPersonActivity.sorted_by_date
                                .page(params[:page]).per(100)
    end
end
