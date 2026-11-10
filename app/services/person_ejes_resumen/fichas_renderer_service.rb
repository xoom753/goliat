class PersonEjesResumen::FichasRendererService
    delegate :tipo_porcentual?, to: :@person_ejes_resumen
    def initialize(
        docx:,
        kind:,
        person_ejes_resumen:,
        informes_translator_service:,
        periodos_renderer_service:,
        activities_by_periods_renderer_service:
    )
        @docx = docx
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
        @periodos_renderer_service = periodos_renderer_service
        @activities_by_periods_renderer_service = activities_by_periods_renderer_service
    end

    def get_activities_ficha(index)
        activities_fichas.fetch(index)
    end

    def get_grades_ficha(index)
        grades_fichas.fetch(index)
    end

    def get_fichas_indexes
        if tipo_porcentual?
            [ 0 ]
        else
            0.upto(@periodos_renderer_service.periodos.length-1)
        end
    end

    private

    def activities_fichas
        return @activities_fichas if @activities_fichas

        @activities_fichas = []
        @periodos_renderer_service.periodos.each_with_index do |periodo, index|
            @activities_fichas << ::PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer.new(
                docx: @docx,
                kind: @kind,
                person_ejes_resumen: @person_ejes_resumen,
                informes_translator_service: @informes_translator_service,
                periodos_renderer_service: @periodos_renderer_service,
                activities_by_periods_renderer_service: @activities_by_periods_renderer_service,
                index: index
            )
        end
        @activities_fichas
    end

    def grades_fichas
        return @grades_fichas if @grades_fichas

        @grades_fichas = []
        @periodos_renderer_service.periodos.each_with_index do |periodo, index|
        @grades_fichas << ::PersonEjesResumen::FichaRendererService::GradesFichaRenderer.new(
                docx: @docx,
                kind: @kind,
                person_ejes_resumen: @person_ejes_resumen,
                informes_translator_service: @informes_translator_service,
                periodos_renderer_service: @periodos_renderer_service,
                activities_by_periods_renderer_service: @activities_by_periods_renderer_service,
                index: index
            )
        end
        @grades_fichas
    end
end
