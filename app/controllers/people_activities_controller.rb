class PeopleActivitiesController < ApplicationController
    def index
        scoped = PersonActivity.all.includes(:person, coursable: :activity_group)
        if params[:activity_group_id].present?
            @activities = ActivityGroup.find(params[:activity_group_id]).activities.order_by_name
            scoped = scoped.where(coursable: @activities)
        else
            @activities = Activity.order_by_name
        end
        if params[:activity_id].present?
            activity = Activity.find(params[:activity_id])
            if params[:activity_group_id].blank? || (params[:activity_group_id].present? && @activities.find_by(id: params[:activity_id]))
                scoped = scoped.where(coursable: activity)
            end
        end
        @month = params.dig(:date, :month).presence || Date.today.month
        if @month.present?
            scoped = scoped.where(mes: @month)
        end
        @people_activities = scoped.page(params[:page]).per(50)
    end
end
