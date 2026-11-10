class PersonEjesResumen::SpecificFichaRendererService::FichasLaboralRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    def grades_table
        header_colspan = get_header_colspan
        docx.table grades_table_rows do
            column_widths  [400, 700, 800, 110, 110, 90, 90, 90]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[1], bold: true, align: :center
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], align: :center
            cell_style rows[1][1], vertical_align: :center
            cell_style rows[1][2], align: :center, bold: true
            cell_style rows[2][0], align: :center, vertical_align: :center
            cell_style rows[2][1], vertical_align: :top, align: :left
            cell_style rows[2][2], vertical_align: :top, align: :left
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[2][5], align: :center, vertical_align: :center
            cell_style rows[2][6], align: :center, vertical_align: :center
            cell_style rows[2][7], align: :center, vertical_align: :center
            cell_style rows[3][0], align: :center, bold: true, vertical_align: :center
            cell_style rows[3][1], vertical_align: :top, align: :left
            cell_style rows[3][2], vertical_align: :top, align: :left
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][4], align: :center, vertical_align: :center
            cell_style rows[3][5], align: :center, vertical_align: :center
            cell_style rows[3][6], align: :center, vertical_align: :center
            cell_style rows[3][7], align: :center, vertical_align: :center
            cell_style rows[4][0], colspan: 3, align: :right, bold: true
            cell_style rows[4][1], align: :center, bold: true
            cell_style rows[4][2], align: :center, bold: true
            cell_style rows[4][1], align: :center, bold: true
            cell_style rows[4][2], align: :center, bold: true
            cell_style rows[4][3], align: :center, bold: true
            cell_style rows[4][4], align: :center, bold: true
            cell_style rows[4][5], align: :center, bold: true
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

        if @person_ejes_resumen.tipo_porcentual?
            semestre = periodos.first.period_percentage
        else
            semestre = @current_periodo.period_percentage
        end

        @grades_table_rows = [
            [
                "Laboral".upcase
            ],
            [
                "Actividades".upcase,
                "Detalles de actividades".upcase,
                "Parámetros de calificación".upcase,
                "Máx".upcase,
                semestre
            ],
            [
                "Permanente".upcase,
                "Proyectos institucionales y/o producción en talleres",
                "Cumplimiento a los horarios, convivencia, protocolos de seguridad y conocimientos",
                "3",
                "0"
            ],
            [
                "Temporal".upcase,
                "Actividades ocupacionales, capacitación, servicios auxiliares y terapia ocupacional",
                "Asistencia, cumplimiento a los horarios, comportamiento, protocolos de seguridad, aprobación y conocimiento",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                "5",
                temp_grade.to_s
            ]
        ]

        concat_tipo_porcentual_rows!(@grades_table_rows) if @person_ejes_resumen.tipo_porcentual?

        @grades_table_rows
    end
end
