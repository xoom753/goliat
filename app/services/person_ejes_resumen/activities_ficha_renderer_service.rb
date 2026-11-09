class PersonEjesResumen::ActivitiesFichaRendererService < PersonEjesResumen::GenericFichaRendererService
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
        # if get_activities_within_period.empty?
        # TODO
        docx.p t("common.informe_kind").upcase, bold: true
        if current_periodo.activities.empty?
            info_summary_no_cumple
        else
            info_summary_si_cumple
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

        #todo
        # group_similar_activities
        # @periodos_renderer_service.grouped_activities
        # binding.pry
        # activities = @activities_by_periods_renderer_service.grouped_activities.map do |percentage, activities|
        #     activities.map(&:group_similar_activities)
        # end.flatten
        # activities = activities.map do |activity|
        #     activity.values
        # end.flatten.compact

        # activities = @activities_by_periods_renderer_service.grouped_activities_for_period(
        #     current_periodo
        # )
        # activities.group_similar_activities
        # binding.pry

        activities = current_periodo.activities

        if activities.empty?
            no_registra_temporal = t("common.no_registra_temporal", downcase: true, kind_f: true)
            docx.ol do
                li no_registra_temporal
            end
        else
            docx.ol do
                activities.each do |activity|
                    li activity.render_string
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
                current_periodo.start_date,
                current_periodo.end_date
            ]
        ]
    end

    def info_summary_no_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = t("common.se_informa")
        desde_su_ingreso = t("common.desde_su_ingreso", kind_f: true)
        no_cumple_con_proceso = t(
            "common.no_cumple_con_proceso",
            kind_f: true,
            downcase: true
        )
        docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text no_cumple_con_proceso
        end
    end

    def info_summary_si_cumple
        person_nombres = @person_ejes_resumen.nombres
        se_informa = t("common.se_informa")
        desde_su_ingreso = t("common.desde_su_ingreso", kind_f: true)
        cumple_con_proceso = t("common.cumple_con_proceso", kind_f: true)
        docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text "SÍ", bold: true
            text cumple_con_proceso
        end
    end
end
