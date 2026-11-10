class PersonEjesResumen::FichaRendererService::SummaryRenderer
    delegate :t,
             to: :@informes_translator_service

    def initialize(
            docx:,
            person_ejes_resumen:,
            informes_translator_service:
        )
        @docx = docx
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
    end

    def info_si_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = t("common.se_informa")
        desde_su_ingreso = t("common.desde_su_ingreso", kind_f: true)
        cumple_con_proceso = t("common.cumple_con_proceso", kind_f: true)
        @docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text "SÍ", bold: true
            text cumple_con_proceso
        end
    end

    def info_no_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = t("common.se_informa")
        desde_su_ingreso = t("common.desde_su_ingreso", kind_f: true)
        no_cumple_con_proceso = t(
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
        observaciones = t("common.qualy_observaciones")
        durante_el_tiempo = t("common.qualy_durante_el_tiempo")
        cumple_con = t("common.qualy_cumple_con")
        @docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text "SÍ", bold: true
            text cumple_con
        end
    end

    def grades_no_cumple
        observaciones = t("common.qualy_observaciones")
        durante_el_tiempo = t("common.qualy_durante_el_tiempo")
        qualy_no_cumple_con = t("common.qualy_no_cumple_con")
        @docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text qualy_no_cumple_con
        end
    end
end
