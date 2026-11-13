class PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosPorcentualesRenderer < PersonEjesResumen::ByTipoPeriodoRendererService::GenericPeriodosRenderer
    def get_grades_table_merged_rows_count
        get_info_table_merged_rows_count
    end

    def ficha_info_table_bottom_rows
        []
    end

    def info_actividades_permanentes_list
        # no permanentes para porcentuales
    end

    def grades_ficha_bottom_rows
        @periodos.inject([]) do |memo, periodo|
                memo << [
                        "Periodo #{periodo.period_percentage}".upcase,
                        periodo.start_date_str,
                        periodo.end_date_str
                    ]
                memo
            end
    end

    def get_kind_specific_table_header_colspan
        remaining_periods = @periodos.drop(1)
        KIND_SPECIFIC_TABLE_HEADER_COLSPAN_BASE + remaining_periods.length
    end

    def get_semestre
        @periodos.first.period_percentage
    end

    def concat_tipo_porcentual_rows!(table_rows)
        remaining_periods = @periodos.drop(1)
        grades = remaining_periods.map do |remaining_period|
            if remaining_period.activities.length > 0
                "2"
            else
                "0"
            end
        end
        table_rows.each_with_index do |row, index|
            if index == 1
                row.concat remaining_periods.map(&:period_percentage)
            # elsif index == 2
            #     # permanente row
            #     row.concat remaining_periods.map {|_| "0" }
            elsif index > 1
                row.concat grades
            end
        end
    end

    def get_subtotal_max_grade
        "2"
    end

    protected

    def extra_info_table_merged_rows
        0 # because porcentual does not include "temporalidad" row
    end

    def get_activities
        # all activities
        @activities_by_periods_renderer_service.grouped_activities.map do |grouped_activities|
            grouped_activities.activities
        end.flatten
    end
end
