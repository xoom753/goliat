class PersonEjesResumen::InformeRendererService
    delegate :header,
             :footer,
             :signature,
             :fecha_entrega,
             :generic_styles,
             to: :generic_informe_renderer

    delegate :get_grades_ficha,
             :get_activities_ficha,
             :get_fichas_indexes,
             to: :fichas_renderer

    delegate :draft_activities_list,
             :draft_info_si_cumple,
             :draft_info_no_cumple,
             :draft_grades_si_cumple,
             :draft_grades_no_cumple,
             :draft_template_title,
             to: :draft_ficha_renderer_service

    attr_accessor :docx

    def initialize(person_ejes_resumen:, kind:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = PersonEjesResumen::ActivityToHumanRendererService::InformesTranslator.new(
            kind: @kind
        )
    end

    def periodos
        periodos_renderer_service.periodos
    end

    private

    def generic_informe_renderer
        @generic_informe_renderer ||= PersonEjesResumen::InformeRendererService::GenericInformeRenderer.new(
            docx: docx,
            activities_by_periods_renderer_service: activities_by_periods_renderer_service
        )
    end

    def fichas_renderer
        @fichas_renderer ||= PersonEjesResumen::FichasRendererService.new(
            docx: docx,
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen,
            informes_translator_service: @informes_translator_service,
            periodos_renderer_service: periodos_renderer_service,
            activities_by_periods_renderer_service: activities_by_periods_renderer_service
        )
    end

    def periodos_renderer_service
        @periodos_renderer ||= PersonEjesResumen::PeriodosRendererService.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        )
    end

    def activities_by_periods_renderer_service
        @activities_by_periods_renderer_service ||= PersonEjesResumen::ActivitiesByPeriodsRendererService.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen,
            periodos_renderer_service: periodos_renderer_service
        )
    end

    def draft_ficha_renderer_service
        @draft_ficha_renderer_service ||= ::PersonEjesResumen::FichaRendererService::DraftFichaRenderer.new(
            docx: @docx,
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen,
            activities_by_periods_renderer_service: activities_by_periods_renderer_service,
            informes_translator_service: @informes_translator_service
        )
    end
end
