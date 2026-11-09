class PersonEjesResumen::GroupedActivitiesRendererService
    def initialize(
            legacy_activities:,
            present_activities:,
            periodos_renderer_service:
        )
        @legacy_activities = legacy_activities
        @present_activities = present_activities
        @periodos_renderer_service = periodos_renderer_service
    end

    def grouped_activities
        by_period_grouped
    end

    private

    def by_period_grouped
        @by_period_grouped ||= ::PersonEjesResumen::GroupedActivitiesByPeriodRendererService.new(
            activities: all_activities,
            periodos_renderer_service: @periodos_renderer_service
        ).by_periods
    end

    def all_activities
        legacy_activities + present_activities
    end

    def legacy_activities
        @legacy_activities.map do |legacy_activity|
            ::PersonEjesResumen::LegacyActivityRendererService.new(
                current_activity: legacy_activity
            )
        end
    end

    def present_activities
        @present_activities.map do |present_activity|
            ::PersonEjesResumen::PresentActivityRendererService.new(
                current_activity: present_activity
            )
        end
    end
end

