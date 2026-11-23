class PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoActualRenderer
    delegate :t,
             to: I18n

    def initialize(
            docx:,
            semestre:,
            periodos:,
            person_ejes_resumen:
        )
        @docx = docx
        @semestre = semestre
        @periodos = periodos
        @person_ejes_resumen = person_ejes_resumen
    end

    def table
        table_col_widths = get_table_col_widths
        @docx.table table_rows do
            column_widths table_col_widths
            border_size 4
            cell_style rows[0], bold: true, align: :center
            cell_style cols[2], align: :center
            cell_style cols[3], align: :center
        end
    end

    private

    def get_table_col_widths
        cols_widths = [ 700, 1300, 400 ]
        if @person_ejes_resumen.tipo_porcentual?
            cols_widths.concat( @periodos.map { 200 } )
        else
            cols_widths << 200
        end
        cols_widths << 500
        cols_widths
    end

    def table_rows
        rows = get_table_rows_first_part
        if @person_ejes_resumen.tipo_porcentual?
            concat_remaining_periods!(rows)
        end
        rows.each_with_index do |row, index|
            row.concat(
                Array(
                    table_rows_last_cols[index]
                )
            )
        end
        rows
    end

    def table_rows_last_cols
        @table_rows_last_cols ||= [
            "Justificación de la calificación".upcase,
            "Sí cumple",
            "Sí cumple",
            "Charlas motivacionales individuales",
            "Orientaciones psicológicas grupales"
        ]
    end

    def concat_remaining_periods!(rows)
        remaining_periods = @periodos.drop(1)
        remaining_periods.each do |remaining_period|
            cols_for_period = get_cols_for_period(remaining_period.period_percentage)
            rows.each_with_index do |row, index|
                row.concat(
                    Array(
                        cols_for_period[index]
                    )
                )
            end
        end
    end

    def get_cols_for_period(period_percentage)
        [
            period_percentage,
            "0,50",
            "0,50",
            @person_ejes_resumen.tipo_porcentual? ? "0,25" : "1",
            @person_ejes_resumen.tipo_porcentual? ? "0,25" : "1",
        ]
    end

    def get_table_rows_first_part
        first_period_cols = get_cols_for_period(@semestre)
        [
            [
                "Actividades".upcase,
                "Detalles de actividades".upcase,
                "Puntaje".upcase,
                first_period_cols[0]
            ],
            [
                t("person_ejes_resumen.social_report.permanente_disciplina"),
                t("person_ejes_resumen.social_report.permanente_respeto"),
                "0,50 puntos",
                first_period_cols[1]
            ],
            [
                t("person_ejes_resumen.social_report.permanente_disciplina"),
                t("person_ejes_resumen.social_report.permanente_comportamiento"),
                "0,50 puntos",
                first_period_cols[2]
            ],
            [
                t("person_ejes_resumen.social_report.temporal_capacitaciones"),
                t("person_ejes_resumen.social_report.temporal_participacion"),
                @person_ejes_resumen.tipo_porcentual? ? "0,50 puntos" : "2 puntos",
                first_period_cols[3]
            ],
            [
                t("person_ejes_resumen.social_report.permanente_apoyo"),
                t("person_ejes_resumen.social_report.permanente_participacion"),
                @person_ejes_resumen.tipo_porcentual? ? "0,50 puntos" : "2 puntos",
                first_period_cols[4]
            ]
        ]
    end
end
