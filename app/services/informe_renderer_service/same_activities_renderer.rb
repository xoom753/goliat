class InformeRendererService::SameActivitiesRenderer
    def initialize(person_activities)
        @person_activities = person_activities
    end

    def summarised_activities
        by_months = @person_activities.inject({}) do |memo, person_activity|
            memo[person_activity.month] = person_activity
            memo
        end
        if by_months.values.length > 1
            ::LegacyPeopleActivitiesRendererService::GroupedActivitiesCertRenderer.new(
                person_activities: by_months.values
            )
        else
            by_months.values.first
        end
    end
end
