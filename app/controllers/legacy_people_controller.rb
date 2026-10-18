class LegacyPeopleController < ApplicationController
    def index
        @legacy_people = LegacyPerson.all
                                     .includes(legacy_person_activities: [:legacy_activity, :legacy_activity_group])
                                     .page(params[:page])
                                     .per(50)
    end
end
