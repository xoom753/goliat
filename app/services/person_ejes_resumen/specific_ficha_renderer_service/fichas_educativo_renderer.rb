class PersonEjesResumen::SpecificFichaRendererService::FichasEducativoRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    def grades_table
        header_colspan = get_kind_specific_table_header_colspan
        column_widths = [ 300, 400, 800, 110, 110, 90, 90, 90 ]

        permanente_row = 2
        temporal_row = tipo_porcentual? ? 2 : 4

        tipo_porcentual = tipo_porcentual?

        docx.table grades_table_rows do
            column_widths column_widths
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[1], bold: true, align: :center
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], align: :center, colspan: 3
            cell_style rows[1][1], vertical_align: :center
            cell_style rows[1][2], align: :center, bold: true

            unless tipo_porcentual
                cell_style rows[permanente_row][0], align: :center, vertical_align: :center, rowspan: 2
                cell_style rows[permanente_row][1], vertical_align: :center, bold: true
                cell_style rows[permanente_row][3], align: :center, vertical_align: :center, rowspan: 2
                cell_style rows[permanente_row][4], align: :center, vertical_align: :center, rowspan: 2
                cell_style rows[permanente_row][5], align: :center, vertical_align: :center
                cell_style rows[permanente_row][6], align: :center, vertical_align: :center
                cell_style rows[permanente_row][7], align: :center, vertical_align: :center
                cell_style rows[permanente_row + 1][1], vertical_align: :center, bold: true
            end

            cell_style rows[temporal_row][0], align: :center, bold: true, vertical_align: :center
            cell_style rows[temporal_row][1], vertical_align: :center, bold: true
            cell_style rows[temporal_row][2], vertical_align: :top
            cell_style rows[temporal_row][3], align: :center, vertical_align: :center
            cell_style rows[temporal_row][3], align: :center, vertical_align: :center
            cell_style rows[temporal_row][4], align: :center, vertical_align: :center
            cell_style rows[temporal_row][5], align: :center, vertical_align: :center
            cell_style rows[temporal_row][6], align: :center, vertical_align: :center
            cell_style rows[temporal_row][7], align: :center, vertical_align: :center

            cell_style rows[temporal_row + 1][0], colspan: 3, align: :right, bold: true
            cell_style rows[temporal_row + 1][1], align: :center, bold: true
            cell_style rows[temporal_row + 1][2], align: :center, bold: true
            cell_style rows[temporal_row + 1][1], align: :center, bold: true
            cell_style rows[temporal_row + 1][2], align: :center, bold: true
            cell_style rows[temporal_row + 1][3], align: :center, bold: true
            cell_style rows[temporal_row + 1][4], align: :center, bold: true
            cell_style rows[temporal_row + 1][5], align: :center, bold: true
        end

        docx.p
    end

    private

    def get_kind_specific_table_header_colspan
        # educativo has an additional column
        @by_tipo_periodo_renderer.get_kind_specific_table_header_colspan + 1
    end

    def grades_table_rows_first_part
        [
            [
                "Educativo".upcase
            ],
            [
                "Parámetros de calificación".upcase,
                "Máx".upcase,
                get_semestre
            ]
        ]
    end

    def grades_table_permanente_rows
        [
            [
                "Permanente".upcase,
                "Educación escolarizada".upcase,
                "Docentes voluntarios por periodo académico; o estudiantes regulares en alfabetización, post-alfabetización, educación básica superior, bachillerato general unificado y bachillerato técnico.",
                "5",
                "0"
            ],
            [
                "",
                "Educación superior".upcase,
                "Diferentes carreras universitarias.",
                "",
                ""
            ]
        ]
    end

    def grades_table_rows_last_part
        subtotal_max_grade = if tipo_porcentual?
            "2"
        else
            "7"
        end
        [
            [
                "Temporal".upcase,
                "Educación no escolarizada".upcase,
                "Tutorías, cursos, talleres, charlas, biblioteca y otras actividades de capacitación recibidas.",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                subtotal_max_grade,
                temp_grade.to_s
            ]
        ]
    end
end
