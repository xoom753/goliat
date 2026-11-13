class PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosSemestralesRenderer < PersonEjesResumen::ByTipoPeriodoRendererService::GenericPeriodosRenderer
    def get_grades_table_merged_rows_count
        qualy_table_merged_rows_count = get_info_table_merged_rows_count
        qualy_table_merged_rows_count - 1 # because it does not include "temporalidad" row
    end

    def ficha_info_table_bottom_rows
        [
            [
                "Temporalidad".upcase,
                @current_periodo.period_percentage
            ],
            [
                "Semestre".upcase,
                date_to_str(@current_periodo.start_date),
                date_to_str(@current_periodo.end_date)
            ]
        ]
    end

    def info_actividades_permanentes_list
        @docx.p t("common.act_permanente").upcase, bold: true
        no_registra_permanente = t("common.no_registra_permanente", downcase: true, kind_f: true)
        @docx.ol do
            li no_registra_permanente
        end
        @docx.p
    end

    def grades_ficha_bottom_rows
        [
            [
                @current_periodo.semestre_str.upcase,
                date_to_str(@current_periodo.start_date),
                date_to_str(@current_periodo.end_date)
            ]
        ]
    end

    def get_kind_specific_table_header_colspan
        KIND_SPECIFIC_TABLE_HEADER_COLSPAN_BASE
    end

    def get_semestre
        @current_periodo.period_percentage
    end

    def concat_tipo_porcentual_rows!(rows)
      # doing nothing for semestrales
    end

    def get_subtotal_max_grade
        "5"
    end

    protected

    def extra_info_table_merged_rows
        1 # because semestral includes "temporalidad" row
    end

    def get_activities
        @current_periodo.activities
    end
end
