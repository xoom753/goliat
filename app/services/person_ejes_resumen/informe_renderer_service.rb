##
# is parent for:
# InformeCulturalRendererService
class PersonEjesResumen::InformeRendererService
    # cattr_accessor :kind

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

    attr_accessor :docx

    def initialize(person_ejes_resumen:, kind:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = PersonEjesResumen::InformesTranslatorService.new(
            kind: @kind
        )
    end

    private

    def generic_informe_renderer
        @generic_informe_renderer ||= PersonEjesResumen::GenericInformeRendererService.new(
            docx: docx
        )
    end

    def fichas_renderer
        @fichas_renderer ||= PersonEjesResumen::FichasRendererService.new(
            docx: docx,
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen,
            informes_translator_service: @informes_translator_service,
            periodos_renderer_service: periodos_renderer_service
        )
    end

    def periodos_renderer_service
        @periodos_renderer ||= PersonEjesResumen::PeriodosRendererService.new(
            person_ejes_resumen: @person_ejes_resumen
        )
    end
end
