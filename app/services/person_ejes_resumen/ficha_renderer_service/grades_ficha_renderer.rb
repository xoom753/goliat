class PersonEjesResumen::FichaRendererService::GradesFichaRenderer < PersonEjesResumen::FichaRendererService::GenericFichaRenderer
    delegate :grades_si_cumple,
             :grades_no_cumple,
             to: :summary_renderer

    def title
        docx.h1 t("common.qualy_main_title").upcase, align: :center
        docx.h1 t("common.qualy_main_subtitle", kind_f: true).upcase, align: :center
        docx.p
    end

    def intro
        docx.p t("common.qualy_datos").upcase, bold: true
        docx.p
    end

    def info_table
        qualy_table_merged_rows_count = get_info_table_merged_rows_count
        qualy_table_merged_rows_count -= 1 unless tipo_porcentual?
        docx.table(
            common_table_rows + ficha_qualy_bottom_rows
        ) do
            cell_style cols[0], bold: true
            0.upto(qualy_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end

        docx.p
    end

    def grades_table
        docx.h1 t("common.qualy_main_table_title").upcase, align: :center
        docx.p

        specific_renderer.grades_table
    end

    def grades_summary
        if current_periodo.activities.empty?
            grades_no_cumple
        else
            grades_si_cumple
        end
        docx.p
    end

    private

    def ficha_qualy_bottom_rows
        if tipo_porcentual?
            periodos.inject([]) do |memo, periodo|
                memo << [
                        "Periodo #{periodo.period_percentage}".upcase,
                        periodo.start_date_str,
                        periodo.end_date_str
                    ]
                memo
            end
        else
            [
                [
                    current_periodo.semestre_str.upcase,
                    date_to_str(current_periodo.start_date),
                    date_to_str(current_periodo.end_date)
                ]
            ]
        end
    end
end
