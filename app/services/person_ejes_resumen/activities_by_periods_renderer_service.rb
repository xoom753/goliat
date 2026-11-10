class PersonEjesResumen::ActivitiesByPeriodsRendererService
    def initialize(
        kind:,
        person_ejes_resumen:,
        periodos_renderer_service:
    )
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @periodos_renderer_service = periodos_renderer_service
    end

    def grouped_activities
        @grouped_activities ||= PersonEjesResumen::GroupedActivitiesRendererService.new(
            periodos_renderer_service: @periodos_renderer_service,
            legacy_activities: legacy_activities,
            present_activities: present_activities
        ).grouped_activities
    end

    private

    def legacy_activities
        PersonEjesResumen::LegacyActivitiesFetcherService.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).activities
    end

    def present_activities
        PersonEjesResumen::PresentActivitiesFetcherService.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).activities
    end
end
