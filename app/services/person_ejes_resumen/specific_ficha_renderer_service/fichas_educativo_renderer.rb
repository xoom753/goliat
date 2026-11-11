class PersonEjesResumen::SpecificFichaRendererService::FichasEducativoRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    def grades_table
        header_colspan = get_header_colspan
        docx.table grades_table_rows do
            column_widths  [400, 400, 1000, 110, 110, 90, 90, 90]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[1], bold: true, align: :center
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], align: :center, colspan: 3
            cell_style rows[2][0], align: :center, bold: true, vertical_align: :center
            cell_style rows[2][1], vertical_align: :center, align: :left
            cell_style rows[2][2], vertical_align: :top, align: :left
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[2][5], align: :center, vertical_align: :center
            cell_style rows[2][6], align: :center, vertical_align: :center
            cell_style rows[2][7], align: :center, vertical_align: :center
            cell_style rows[3][0], colspan: 3, align: :right, bold: true
            cell_style rows[3][1], align: :center, bold: true
            cell_style rows[3][2], align: :center, bold: true
            cell_style rows[3][1], align: :center, bold: true
            cell_style rows[3][2], align: :center, bold: true
            cell_style rows[3][3], align: :center, bold: true
            cell_style rows[3][4], align: :center, bold: true
            cell_style rows[3][5], align: :center, bold: true
        end

        docx.p
    end

    private

    def get_header_colspan
        header_colspan = 5
        if @person_ejes_resumen.tipo_porcentual?
            remaining_periods = periodos.drop(1)
            header_colspan += remaining_periods.length
        end
        header_colspan
    end

    def grades_table_rows
        return @grades_table_rows if @grades_table_rows

        @grades_table_rows = [
            [
                "Educativo".upcase
            ],
            [
                "Parámetros de calificación".upcase,
                "Máx".upcase,
                get_semestre
            ],
            [
                "Temporal".upcase,
                "Educación no escolarizada".upcase,
                "Tutorías, cursos, talleres, charlas, biblioteca y otras actividades de capacitación recibidas.",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                "2",
                temp_grade.to_s
            ]
        ]

        concat_tipo_porcentual_rows!(@grades_table_rows) if @person_ejes_resumen.tipo_porcentual?

        @grades_table_rows
    end
end
