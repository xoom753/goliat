# Combines present and legacy activities into period-based groups for reports.
class PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesRenderer
    # @param legacy_activities [Array] historical activities
    # @param present_activities [Array] current activities
    # @param periodos_renderer_service [PersonEjesResumen::PeriodosRendererService] periods receiving activities
    def initialize(
            legacy_activities:,
            present_activities:,
            periodos_renderer_service:
        )
        @legacy_activities = legacy_activities
        @present_activities = present_activities
        @periodos_renderer_service = periodos_renderer_service
    end

    # Returns grouped activities with period summaries attached.
    # @return [Array] grouped activity objects
    def grouped_activities
        by_period_grouped
    end

    private

    def by_period_grouped
        @by_period_grouped ||= ::PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesByPeriodRenderer.new(
            activities: all_activities,
            periodos_renderer_service: @periodos_renderer_service
        ).by_periods
    end

    ##
    # sort activities by date
    def all_activities
        (
            present_activities + legacy_activities
        ).sort_by(&:end_date)
    end

    def legacy_activities
        @legacy_activities.map do |legacy_activity|
            ::PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer.new(
                current_activity: legacy_activity
            )
        end
    end

    def present_activities
        @present_activities.map do |present_activity|
            ::PersonEjesResumen::ActivityRendererService::PresentActivityRenderer.new(
                current_activity: present_activity
            )
        end
    end
end
