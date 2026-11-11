class PersonEjesResumen::ActivitiesGroupService::SummariseActivityForPeriod
    attr_reader :kind

    delegate :actividad_kind,
             :activity_str,
             :meses_y_anios_str,
             :duracion_str,
             to: :@activity_to_human_render_service

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
        @activity_to_human_render_service.to_string
    end

    ##
    # { date => act }
    def by_months
        @activities.inject({}) do |memo, activity|
            memo[activity.end_date] = activity
            memo
        end
    end

    private

    def duracion_i
        by_months.values.inject(0) do |memo, value|
            memo += value.duracion_i
            memo
        end
    end
end
