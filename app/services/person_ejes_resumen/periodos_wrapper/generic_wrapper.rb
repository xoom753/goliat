# Stores a report period's dates and activities and exposes shared period operations.
class PersonEjesResumen::PeriodosWrapper::GenericWrapper
    FORMATO_ANTIGUO_DATE = Date.new(2020, 12, 20)

    attr_reader :period_percentage, :start_date, :end_date

    delegate :date_to_str, to: PersonEjesResumen

    # Indicates whether the period's date range contains the given date.
    # @param date [Date] date to check
    # @return [Boolean]
    def include?(date)
        @date_range.include?(date)
    end

    # Adds an activity to this period.
    # @param activity [Object] activity renderer to include
    # @return [Array] updated activity collection
    def append(activity)
        @activities << activity
    end

    # Returns activity summaries grouped by similar activity name.
    # @return [Array] summarized period activities
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

    # Indicates whether the period starts on or before the legacy-format cutoff.
    # @return [Boolean]
    def is_formato_antiguo?
        @start_date <= FORMATO_ANTIGUO_DATE
    end
end
