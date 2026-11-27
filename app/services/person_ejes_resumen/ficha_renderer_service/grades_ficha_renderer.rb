# Renders grading tables and compliance summaries for one report period.
class PersonEjesResumen::FichaRendererService::GradesFichaRenderer < PersonEjesResumen::FichaRendererService::GenericFichaRenderer
    delegate :grades_si_cumple,
             :grades_no_cumple,
             to: :summary_renderer

    delegate :grades_ficha_bottom_rows,
             :get_grades_table_merged_rows_count,
             to: :by_tipo_periodo_renderer

    delegate :grades_table,
             to: :specific_renderer

    # Indicates whether current-format grading content should be included.
    # @return [Boolean]
    def should_render_grades_ficha?
        !current_periodo.is_formato_antiguo?
    end

    def title
        docx.h1 stringify("common.qualy_main_title").upcase, align: :center
        docx.h1 stringify("common.qualy_main_subtitle", kind_f: true).upcase, align: :center
        docx.p
    end

    def intro
        docx.p stringify("common.qualy_datos").upcase, bold: true
        docx.p
    end

    def info_table
        grades_table_merged_rows_count = get_grades_table_merged_rows_count
        docx.table(
            common_table_rows + grades_ficha_bottom_rows
        ) do
            cell_style cols[0], bold: true
            0.upto(grades_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5 }
        end

        docx.p
    end

    def grades_table_title
        docx.h1 stringify("common.qualy_main_table_title").upcase, align: :center
        docx.p
    end

    # Renders the grading compliance summary based on activity in the report.
    # @return [void]
    def grades_summary
        if has_any_activity?
            grades_si_cumple
        else
            grades_no_cumple
        end
        docx.p
    end
end
