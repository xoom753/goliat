class LegacyPersonActivitiesController < ApplicationController
    def index
        scope = LegacyPersonActivity.sorted_by_date
        if params[:date_from].present? && params[:date_to].present?
            scope = scope.where(
                end_date: params[:date_from]..params[:date_to]
            )
        end
        if params[:activity_group_id].present?
            legacy_activity_groups = ActivityGroup.find(
                params[:activity_group_id]
            ).legacy_activity_groups
            scope = scope.where(
                legacy_activity_group: legacy_activity_groups
            )
        end
        if params[:activity_group_id].present?
            @activities = LegacyActivity.where(
                id: scope.pluck(:legacy_activity_id)
            )
        end
        if params[:legacy_activity_id].present?
            scope = scope.where(
                legacy_activity_id: params[:legacy_activity_id]
            )
        end
        @legacy_person_activities = scope.page(params[:page]).per(100)
    end
end
