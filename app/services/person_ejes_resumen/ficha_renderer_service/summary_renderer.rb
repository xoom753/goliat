# Renders narrative compliance and grading summaries for report fichas.
class PersonEjesResumen::FichaRendererService::SummaryRenderer
    delegate :stringify,
             to: :@informes_translator_service

    # @param docx [Object] document receiving summary paragraphs
    # @param person_ejes_resumen [PersonEjesResumen] report subject
    # @param informes_translator_service [Object] translation adapter
    def initialize(
            docx:,
            person_ejes_resumen:,
            informes_translator_service:
        )
        @docx = docx
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
    end

    # Renders the narrative that the person meets the process requirements.
    # @return [void]
    def info_si_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = stringify("common.se_informa")
        desde_su_ingreso = stringify("common.desde_su_ingreso", kind_f: true)
        cumple_con_proceso = stringify("common.cumple_con_proceso", kind_f: true)
        @docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text "SÍ", bold: true
            text cumple_con_proceso
        end
    end

    # Renders the narrative that the person does not meet the process requirements.
    # @return [void]
    def info_no_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = stringify("common.se_informa")
        desde_su_ingreso = stringify("common.desde_su_ingreso", kind_f: true)
        no_cumple_con_proceso = stringify(
            "common.no_cumple_con_proceso",
            kind_f: true,
            downcase: true
        )
        @docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text no_cumple_con_proceso
        end
    end

    def grades_si_cumple
        observaciones = stringify("common.qualy_observaciones")
        durante_el_tiempo = stringify("common.qualy_durante_el_tiempo")
        cumple_con = stringify("common.qualy_cumple_con")
        @docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text "SÍ", bold: true
            text cumple_con
        end
    end

    def grades_no_cumple
        observaciones = stringify("common.qualy_observaciones")
        durante_el_tiempo = stringify("common.qualy_durante_el_tiempo")
        qualy_no_cumple_con = stringify("common.qualy_no_cumple_con")
        @docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text qualy_no_cumple_con
        end
    end
end
