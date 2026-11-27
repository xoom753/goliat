# Groups activity renderers by their human-readable activity name.
class PersonEjesResumen::ActivitiesGroupService::GroupSimilarActivities
    # @param kind [Symbol] treatment axis for the activity summaries
    # @param activities [Array] rendered activities to group
    def initialize(kind:, activities:)
        @kind = kind
        @activities = activities
    end

    # Returns summaries keyed by normalized activity name.
    # @return [Hash<String, PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod>]
    def grouped
        summarised_activities_for_period
    end

    private

    ##
    # { act1Name => [r1, r2] }
    def by_activities
        @activities.inject({}) do |memo, activity|
            memo[activity.activity_human_name_d] ||= []
            memo[activity.activity_human_name_d] << activity
            memo
        end
    end

    def summarised_activities_for_period
        by_activities.inject({}) do |memo, (key, activities)|
            memo[key] = PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod.new(
                kind: @kind,
                activities: activities
            )
            memo
        end
    end
end
