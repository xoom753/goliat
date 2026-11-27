# Fetches legacy and present activities, then groups them against report periods.
class PersonEjesResumen::ActivitiesByPeriodsRendererService
    # @param kind [Symbol] treatment axis used to select activity sources
    # @param person_ejes_resumen [PersonEjesResumen] report whose activities are rendered
    # @param periodos_renderer_service [PersonEjesResumen::PeriodosRendererService] report period provider
    def initialize(
        kind:,
        person_ejes_resumen:,
        periodos_renderer_service:
    )
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @periodos_renderer_service = periodos_renderer_service
    end

    # Returns cached activity groups for the report periods.
    # @return [Array] grouped activities
    def grouped_activities
        @grouped_activities ||= PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesRenderer.new(
            periodos_renderer_service: @periodos_renderer_service,
            legacy_activities: legacy_activities,
            present_activities: present_activities
        ).grouped_activities
    end

    private

    def legacy_activities
        PersonEjesResumen::ActivitiesFetcherService::LegacyActivitiesFetcher.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).activities
    end

    def present_activities
        PersonEjesResumen::ActivitiesFetcherService::PresentActivitiesFetcher.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).activities
    end
end
