class PersonEjesResumen::SummariseActivityForPeriodService
    def initialize(activities:)
        @activities = activities
    end

    def render_string
        "#{months.join(", ")} #{activity_str} #{duracion_i} horas"
    end

    def activity_str
        by_month.values.first.activity_nombre
    end

    def duracion_i
        by_month.values.inject(0) do |memo, value|
            memo += value.duracion_i
            memo
        end
    end

    def months
        by_month.values.map do |activity_renderer_service|
            activity_renderer_service.month
        end
    end

    private

    ##
    # { date => act }
    def by_month
        @activities.inject({}) do |memo, activity|
            memo[activity.end_date] = activity
            memo
        end
    end
end
