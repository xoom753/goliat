# Renders draft report sections before a final report is generated.
class PersonEjesResumen::FichaRendererService::DraftFichaRenderer
    delegate :info_si_cumple,
             :info_no_cumple,
             :grades_si_cumple,
             :grades_no_cumple,
             to: :summary_renderer,
             prefix: :draft

    # @param docx [Object] document receiving the draft content
    # @param kind [Symbol] treatment axis
    # @param person_ejes_resumen [PersonEjesResumen] report data
    # @param activities_by_periods_renderer_service [Object] grouped activity provider
    # @param informes_translator_service [Object] report translation adapter
    def initialize(
            kind:,
            docx:,
            person_ejes_resumen:,
            activities_by_periods_renderer_service:,
            informes_translator_service:
        )
        @docx = docx
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
        @activities_by_periods_renderer_service = activities_by_periods_renderer_service
    end

    # Renders the activity list included in the draft.
    # @return [void]
    def draft_activities_list
        @docx.h1 "Todas las actividades"
        @activities_by_periods_renderer_service.grouped_activities.each do |grouped_activities|
            grouped_activities.activities.each do |act|
                @docx.p act.render_string
            end
        end
    end

    # Renders the draft template heading.
    # @return [void]
    def draft_template_title
        @docx.h1 "(Plantillas)", align: :center
    end

    def draft_info_si_cumple
        @docx.h1 "Ficha actividades (sí cumple)"
        summary_renderer.info_si_cumple
        @docx.p
    end

    def draft_info_no_cumple
        @docx.h1 "Ficha actividades (no cumple)"
        summary_renderer.info_no_cumple
        @docx.p
    end

    def draft_grades_si_cumple
        @docx.h1 "Ficha calificaciones (sí cumple)"
        summary_renderer.grades_si_cumple
        @docx.p
    end

    def draft_grades_no_cumple
        @docx.h1 "Ficha calificaciones (no cumple)"
        summary_renderer.grades_no_cumple
        @docx.p
    end

    private

    def summary_renderer
        @summary_renderer ||= ::PersonEjesResumen::FichaRendererService::SummaryRenderer.new(
            docx: @docx,
            person_ejes_resumen: @person_ejes_resumen,
            informes_translator_service: @informes_translator_service
        )
    end
end
