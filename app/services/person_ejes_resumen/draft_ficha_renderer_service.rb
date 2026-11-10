class PersonEjesResumen::DraftFichaRendererService
    delegate :info_si_cumple,
             :info_no_cumple,
             :grades_si_cumple,
             :grades_no_cumple,
             to: :summary_renderer,
             prefix: :draft

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

    def draft_activities_list
        @docx.h1 "Todas las actividades"
        @activities_by_periods_renderer_service.grouped_activities.each do |grouped_activities|
            grouped_activities.activities.each do |act|
                @docx.p act.render_string
            end
        end
    end

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
        @summary_renderer ||= ::PersonEjesResumen::ActivitiesFichaRendererService::SummaryRenderer.new(
            docx: @docx,
            person_ejes_resumen: @person_ejes_resumen,
            informes_translator_service: @informes_translator_service
        )
    end
end
