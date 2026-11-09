class PersonEjesResumen::GroupedActivitiesByPeriodRendererService
    def initialize(
            activities:,
            periodos_renderer_service:
        )
        @activities = activities
        @periodos_renderer_service = periodos_renderer_service
    end

    def by_periods
        all_periodos = @periodos_renderer_service.periodos
        @activities.each do |activity|
            # all_periodos.each do |key, periodos_wrappers|
            #     periodos_wrappers.each do |periodo_wrapper|
            #         if periodo_wrapper.include?(activity.end_date)
            #             periodo_wrapper.append(activity)
            #         end
            #     end
            # end
            all_periodos.each do |periodo_wrapper|
                if periodo_wrapper.include?(activity.end_date)
                    periodo_wrapper.append(activity)
                end
            end
        end
        all_periodos
    end
end
