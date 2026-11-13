class PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer < PersonEjesResumen::FichaRendererService::GenericFichaRenderer
    delegate :info_si_cumple,
             :info_no_cumple,
             to: :summary_renderer

    delegate :ficha_info_table_bottom_rows,
             :get_info_table_merged_rows_count,
             :info_actividades_temporales_list,
             :info_actividades_permanentes_list,
             to: :by_tipo_periodo_renderer

    def title
        docx.h1 t("common.main_title").upcase, align: :center
        docx.h1 t("common.main_subtitle").upcase, align: :center
        docx.p
    end

    def intro
        docx.p t("common.main_intro")
        docx.p
    end

    def info_table
        info_table_merged_rows_count = get_info_table_merged_rows_count

        docx.table(
            common_table_rows + ficha_info_table_bottom_rows
        ) do
            cell_style cols[0], bold: true
            0.upto(info_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end
        docx.p
    end

    def info_summary
        docx.p t("common.informe_kind").upcase, bold: true
        if current_periodo.activities.empty?
            info_no_cumple
        else
            info_si_cumple
        end
        docx.p
    end

    def info_actividades_list
        info_actividades_permanentes_list
        info_actividades_temporales_list
    end

    def info_outro
        docx.p t("common.info_outro_indico")
        docx.p

        if @person_ejes_resumen.ubicacion.present?
            ubicacion = @person_ejes_resumen.ubicacion
            observacion = t("common.info_outro_observacion")
            reside_en = t("common.info_outro_reside_en")
            docx.p do
                text observacion, bold: true
                text " #{reside_en} #{ubicacion}"
            end
        else
            # whitespace
            docx.p
            docx.p
        end
        docx.p
    end
end
