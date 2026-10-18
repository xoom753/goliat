class PeopleActivitiesController < ApplicationController
    def index
        scoped = PersonActivity.all.includes(:person, coursable: :activity_group)
        # todo group
        if params[:activity_id].present?
            scoped = scoped.where(activity_id: params[:activity_id])
        end
        # if params[:date][:month].present?
        #     scoped = scoped.where(mes: params[:date][:month])
        # end
        @people_activities = scoped
    end
end
