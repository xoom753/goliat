class PersonEjesResumen::PeriodosWrapper::GenericWrapper
    attr_reader :period_percentage, :start_date, :end_date

    delegate :date_to_str, to: PersonEjesResumen

    def include?(date)
        @date_range.include?(date)
    end

    def append(activity)
        @activities << activity
    end

    def activities
        group_similar_activities.values
    end

    def group_similar_activities
        PersonEjesResumen::ActivitiesGroupService::GroupSimilarActivities.new(
            kind: @kind,
            activities: @activities
        ).grouped
    end

    def start_date_str
        date_to_str(@start_date)
    end

    def end_date_str
        date_to_str(@end_date)
    end
end
