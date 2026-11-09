class PersonEjesResumen::FichasRendererService
    def initialize(
        docx:,
        kind:,
        person_ejes_resumen:,
        informes_translator_service:,
        periodos_renderer_service:
    )
        @docx = docx
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
        @periodos_renderer_service = periodos_renderer_service
    end

    def get_activities_ficha(index)
        activities_fichas.fetch(index)
    end

    def get_grades_ficha(index)
        grades_fichas.fetch(index)
    end

    def get_fichas_indexes
        # tipo_porcentual? true
        [
            0
        ]
    end

    private

    def activities_fichas
        # tipo_porcentual? true
        @activities_fichas ||= [
            ::PersonEjesResumen::ActivitiesFichaRendererService.new(
                docx: @docx,
                kind: @kind,
                person_ejes_resumen: @person_ejes_resumen,
                informes_translator_service: @informes_translator_service,
                periodos_renderer_service: @periodos_renderer_service
            )
        ]
    end

    def grades_fichas
        @grades_fichas ||= [
            ::PersonEjesResumen::GradesFichaRendererService.new(
                docx: @docx,
                kind: @kind,
                person_ejes_resumen: @person_ejes_resumen,
                informes_translator_service: @informes_translator_service,
                periodos_renderer_service: @periodos_renderer_service
            )
        ]
    end
end
