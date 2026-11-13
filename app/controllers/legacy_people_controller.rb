class LegacyPeopleController < ApplicationController
    def index
        @search_query = params[:q]
        if params[:legacy_people_ids].present?
            @legacy_people = LegacyPerson.where(
                id: params[:legacy_people_ids].split(",")
            )
        elsif @search_query.present?
            @legacy_people = LegacyPerson.where_nombres_like(
                @search_query.strip
            )
        else
            @legacy_people = LegacyPerson.all
        end
        @paginate_activitites = true
        @legacy_people =
            @legacy_people.includes(legacy_person_activities: [
                            :legacy_activity,
                            :legacy_activity_group,
                            :legacy_activity_detail
                        ])
                        .page(params[:page])
                        .per(8)
        # ui tweak for search input
        if params[:legacy_people_ids].present?
            @search_query = @legacy_people.first.try :nombres
        end
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
