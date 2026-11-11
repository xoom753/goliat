class PeopleActivitiesController < ApplicationController
    def index
        scoped = PersonActivity.all.includes(:person, coursable: :activity_group)
        # todo group
        if params[:activity_id].present?
            activity = Activity.find(params[:activity_id])
            scoped = scoped.where(coursable: activity)
        end
        # if params[:date][:month].present?
        #     scoped = scoped.where(mes: params[:date][:month])
        # end
        @people_activities = scoped
    end
end
