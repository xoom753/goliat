class InformeRendererService::GenericRenderer
    attr_accessor :period, :semestre

    delegate :docx,
             :kind,
             :person_ejes_renderer,
             :legacy_person_activities_by_date,
             :tipo_porcentual?,
             :periodos_porcentuales,
             :get_first_period,
             to: :@informe_renderer_service

    def initialize(informe_renderer_service)
        @informe_renderer_service = informe_renderer_service
    end

    def ficha_info_title
        docx.h1 c_t("main_title").upcase, align: :center
        docx.h1 c_t("main_subtitle").upcase, align: :center
        docx.p
    end

    def ficha_info_intro
        docx.p c_t("main_intro")
        docx.p
    end

    def ficha_info_table
        info_table_merged_rows_count = person_ejes_renderer.table_merged_rows_count

        docx.table(
            person_ejes_renderer.common_table_rows + ficha_info_table_bottom_rows
        ) do
            cell_style cols[0], bold: true
            0.upto(info_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end
        docx.p
    end

    def ficha_info_table_bottom_rows
        return [] if tipo_porcentual?

        [
            [
                "Temporalidad".upcase,
                semestre
            ],
            [
                "Semestre".upcase,
                period[:start_date],
                period[:end_date]
            ]
        ]
    end

    def ficha_info_summary
        if get_activities_within_period.empty?
            ficha_info_summary_no_cumple
        else
            ficha_info_summary_si_cumple
        end
    end

    def ficha_info_actividades
        docx.p c_t("act_permanente").upcase, bold: true

        no_registra_permanente = c_t("no_registra_permanente", downcase: true, kind_f: true)
        docx.ol do
            li no_registra_permanente
        end

        docx.p

        docx.p c_t("act_temporal").upcase, bold: true

        activities_within_period = get_activities_within_period
        if get_activities_within_period.empty?
            no_registra_temporal = c_t("no_registra_temporal", downcase: true, kind_f: true)
            docx.ol do
                li no_registra_temporal
            end
        else
            docx.ol do
                activities_within_period.each do |activity_renderer|
                    li "#{activity_renderer.cert_string}."
                end
            end
        end

        docx.p
    end

    def ficha_info_outro
        docx.p c_t("info_outro_indico")

        docx.p

        ubicacion = person_ejes_renderer.ubicacion
        observacion = c_t("info_outro_observacion")
        reside_en = c_t("info_outro_reside_en")
        docx.p do
            text observacion, bold: true
            text " #{reside_en} #{ubicacion}"
        end

        docx.p
    end

    def encargado_title
        docx.p c_t("encargado").upcase, bold: true
    end

    def ficha_qualy_title
        docx.h1 c_t("qualy_main_title").upcase, align: :center
        docx.h1 c_t("qualy_main_subtitle", kind_f: true).upcase, align: :center
        docx.p
    end

    def ficha_qualy_intro
        docx.p c_t("qualy_datos").upcase, bold: true
        docx.p
    end

    def ficha_qualy_info_table
        qualy_table_merged_rows_count = person_ejes_renderer.table_merged_rows_count
        qualy_table_merged_rows_count -= 1 unless tipo_porcentual?
        docx.table(
            person_ejes_renderer.common_table_rows + ficha_qualy_bottom_rows
        ) do
            cell_style cols[0], bold: true
            0.upto(qualy_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end

        docx.p
    end

    def ficha_qualy_bottom_rows
        if tipo_porcentual?
            periodos_porcentuales.inject([]) do |memo, (key, periodos)|
                memo << [
                        "Periodo #{key}".upcase,
                        periodos.first[:start_date],
                        periodos.first[:end_date]
                    ]
                memo
            end
        else
            [
                [
                    period[:semestre_str].upcase,
                    period[:start_date],
                    period[:end_date]
                ]
            ]
        end
    end

    def ficha_qualy_summary
        if get_activities_within_period.empty?
            ficha_qualy_summary_no_cumple
        else
            ficha_qualy_summary_si_cumple
        end
    end

    def template_no_cumple_con_proceso
        docx.p c_t("templates"), align: :center
        docx.p

        ficha_info_summary_no_cumple
    end

    def template_qualy_no_cumple_con
        ficha_qualy_summary_no_cumple
    end

    def draft_activities_title
        docx.p "Borrador de las Actividades Eje #{I18n.t("common.#{kind}")}", align: :center
    end

    def get_activities_within_period
        # return [] if legacy_person_activities_by_date.blank?
        # @periods_cache ||= {}
        # return @periods_cache[period[:end_date]] if @periods_cache[period[:end_date]]
        period_range = get_period_range
        # @periods_cache[period[:end_date]] =
        #     legacy_person_activities_by_date.inject([]) do |memo, (act_date, activities)|
        #         if period_range.include?(act_date)
        #             memo += activities
        #         end
        #         memo
        #     end
        activities_for_period =
            legacy_person_activities_by_date.inject([]) do |memo, (act_date, activities)|
                if period_range.include?(act_date)
                    memo += activities
                end
                memo
            end
        ::InformeRendererService::ActivitiesGroupedRenderer.new(
            activities_for_period
        ).grouped_activities
    end

    protected

    def ficha_qualy_summary_no_cumple
        observaciones = c_t("qualy_observaciones")
        durante_el_tiempo = c_t("qualy_durante_el_tiempo")
        qualy_no_cumple_con = c_t("qualy_no_cumple_con")
        docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text qualy_no_cumple_con
        end
        docx.p
    end

    def ficha_qualy_summary_si_cumple
        observaciones = c_t("qualy_observaciones")
        durante_el_tiempo = c_t("qualy_durante_el_tiempo")
        cumple_con = c_t("qualy_cumple_con")
        docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text "SÍ", bold: true
            text cumple_con
        end
        docx.p
    end

    def ficha_info_summary_si_cumple
        docx.p c_t("informe_kind").upcase, bold: true
        person_nombres = person_ejes_renderer.nombres
        se_informa = c_t("se_informa")
        desde_su_ingreso = c_t("desde_su_ingreso", kind_f: true)
        cumple_con_proceso = c_t("cumple_con_proceso", kind_f: true)
        docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text "SÍ", bold: true
            text cumple_con_proceso
        end
        docx.p
    end

    def ficha_info_summary_no_cumple
        person_nombres = person_ejes_renderer.nombres
        se_informa = c_t("se_informa")
        desde_su_ingreso = c_t("desde_su_ingreso", kind_f: true)
        no_cumple_con_proceso = c_t(
            "no_cumple_con_proceso",
            kind_f: true,
            downcase: true
        )
        docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text no_cumple_con_proceso
        end
        docx.p
    end

    def c_t(key, **options)
        kind_str = I18n.t("common.#{kind}")
        if options[:downcase]
            kind_str = kind_str.downcase
        end
        I18n.t("common.#{key}", **options.merge(kind_str:))
    end

    def get_period_range
        if tipo_porcentual?
            first_periodo = get_first_period
            last_periodo = periodos_porcentuales.values.last.first
            start_date = first_periodo[:start_date]
            end_date = last_periodo[:end_date]
        else
            start_date = period[:start_date]
            end_date = period[:end_date]
        end
        LegacyPersonActivity.parse_date_str(
            start_date
        )..LegacyPersonActivity.parse_date_str(
            end_date
        )
    end
end
