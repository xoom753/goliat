class LegacyPersonActivitiesController < ApplicationController
    def index
        scope = LegacyPersonActivity.sorted_by_date
        if params[:date_from].present? && params[:date_to].present?
            scope = scope.where(
                end_date: params[:date_from]..params[:date_to]
            )
        end
        @legacy_person_activities = scope.page(params[:page]).per(40)
    end
end
