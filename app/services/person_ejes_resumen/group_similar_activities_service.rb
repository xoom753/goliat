class PersonEjesResumen::GroupSimilarActivitiesService
    def initialize(kind:, activities:)
        @kind = kind
        @activities = activities
    end

    def grouped
        summarised_activities_for_period
    end

    private

    ##
    # { act1 => [r1, r2] }
    def by_activities
        @activities.inject({}) do |memo, activity|
            memo[activity.activity_nombre] ||= []
            memo[activity.activity_nombre] << activity
            memo
        end
    end

    def summarised_activities_for_period
        by_activities.inject({}) do |memo, (key, activities)|
            memo[key] = PersonEjesResumen::SummariseActivityForPeriodService.new(
                kind: @kind,
                activities: activities
            )
            memo
        end
    end
end
