class PersonEjesResumen::FichaRendererService::ActivitiesFichaRenderer < PersonEjesResumen::FichaRendererService::GenericFichaRenderer
    delegate :info_si_cumple,
             :info_no_cumple,
             to: :summary_renderer

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
        docx.p t("common.act_permanente").upcase, bold: true
        no_registra_permanente = t("common.no_registra_permanente", downcase: true, kind_f: true)
        docx.ol do
            li no_registra_permanente
        end
        docx.p

        docx.p t("common.act_temporal").upcase, bold: true

        if tipo_porcentual?
            # all activities
            activities = @activities_by_periods_renderer_service.grouped_activities.map do |grouped_activities|
                grouped_activities.activities
            end.flatten
        else
            activities = current_periodo.activities
        end

        if activities.empty?
            no_registra_temporal = t("common.no_registra_temporal", downcase: true, kind_f: true)
            docx.ol do
                li no_registra_temporal
            end
        else
            docx.ol do
                activities.each do |activity|
                    li "#{activity.render_string}."
                end
            end
        end
        docx.p
    end

    def info_outro
        docx.p t("common.info_outro_indico")
        docx.p

        ubicacion = @person_ejes_resumen.ubicacion
        observacion = t("common.info_outro_observacion")
        reside_en = t("common.info_outro_reside_en")
        docx.p do
            text observacion, bold: true
            text " #{reside_en} #{ubicacion}"
        end
        docx.p
    end

    private

    def ficha_info_table_bottom_rows
        return [] if tipo_porcentual?

        [
            [
                "Temporalidad".upcase,
                current_periodo.period_percentage
            ],
            [
                "Semestre".upcase,
                date_to_str(current_periodo.start_date),
                date_to_str(current_periodo.end_date)
            ]
        ]
    end
end
