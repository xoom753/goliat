class PersonEjesResumen::SummariseActivityForPeriodService
    def initialize(kind:, activities:)
        @kind = kind
        @activities = activities
        @activity_to_human_render_service = ::PersonEjesResumen::ActivityToHumanRendererService.new(
            kind: @kind,
            activities: @activities,
            duracion_i: duracion_i,
            by_months: by_months
        )
    end

    def render_string
        # "#{months.join(", ")} #{activity_str} #{duracion_i} horas"
        @activity_to_human_render_service.to_string
    end

    # def activity_str
    #     by_month.values.first.activity_nombre
    # end



    # def months
    #     by_month.values.map do |activity_renderer_service|
    #         activity_renderer_service.month
    #     end
    # end

    private

    def duracion_i
        by_months.values.inject(0) do |memo, value|
            memo += value.duracion_i
            memo
        end
    end

    ##
    # { date => act }
    def by_months
        @activities.inject({}) do |memo, activity|
            memo[activity.end_date] = activity
            memo
        end
    end
end
