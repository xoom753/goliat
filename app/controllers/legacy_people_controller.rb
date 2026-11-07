class LegacyPeopleController < ApplicationController
    def index
        if params[:legacy_people_ids].present?
            @legacy_people = LegacyPerson.where(
                id: params[:legacy_people_ids].split(",")
            )
        elsif params[:q].present?
            @legacy_people = LegacyPerson.where(
                "nombres LIKE '%#{params[:q].strip}%'"
            )
        else
            @legacy_people = LegacyPerson.all
        end
        @paginate_activitites = true
        @legacy_people =
            @legacy_people.includes(legacy_person_activities: [
                            :legacy_activity,
                            :legacy_activity_group,
                            :legacy_activity_detail,
                        ])
                        .page(params[:page])
                        .per(8)
    end

    def show
        @legacy_people = LegacyPerson.where(id: params[:id])
    end

    def view_several
        @legacy_people = LegacyPerson.where(
            id: params[:legacy_people_ids].split(",")
        )
        render :show
    end
end
