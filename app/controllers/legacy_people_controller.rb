class LegacyPeopleController < ApplicationController
    def index
        if params[:q].present?
            @legacy_people = LegacyPerson.where(
                "nombres LIKE '%#{params[:q]}%'"
            )
        else
            @legacy_people = LegacyPerson.all
        end
        @legacy_people =
            @legacy_people.includes(legacy_person_activities: [
                            :legacy_activity,
                            :legacy_activity_group,
                            :legacy_activity_detail,
                        ])
                        .page(params[:page])
                        .per(20)
    end
end
