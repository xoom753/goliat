# Assigns rendered activities to the report periods that contain their dates.
class PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesByPeriodRenderer
    # @param activities [Array] rendered activities to place into periods
    # @param periodos_renderer_service [PersonEjesResumen::PeriodosRendererService] period provider
    def initialize(
            activities:,
            periodos_renderer_service:
        )
        @activities = activities
        @periodos_renderer_service = periodos_renderer_service
    end

    # Returns grouped activities keyed to their matching periods.
    # @return [Array] grouped period activities
    def by_periods
        all_periodos = @periodos_renderer_service.periodos
        @activities.each do |activity|
            all_periodos.each do |periodo_wrapper|
                if periodo_wrapper.include?(activity.end_date)
                    periodo_wrapper.append(activity)
                end
            end
        end
        all_periodos
    end
end
