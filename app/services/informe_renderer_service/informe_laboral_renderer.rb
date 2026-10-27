class InformeRendererService::InformeLaboralRenderer < InformeRendererService::GenericRenderer
    def ficha_qualy_main_table
        docx.h1 c_t("qualy_main_table_title").upcase, align: :center
        docx.p

        docx.table [
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
                "2"
            ],
            [
                "Subtotal",
                "5",
                "2"
            ]
        ] do
            column_widths  [400, 700, 800, 110, 110]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[1], bold: true, align: :center
            cell_style rows[0][0], colspan: 5, align: :center
            cell_style rows[1][0], align: :center
            cell_style rows[1][1], vertical_align: :center
            cell_style rows[1][2], align: :center, bold: true
            cell_style rows[2][0], align: :center, vertical_align: :center
            cell_style rows[2][1], vertical_align: :top, align: :left
            cell_style rows[2][2], vertical_align: :top, align: :left
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[3][0], align: :center, bold: true, vertical_align: :center
            cell_style rows[3][1], vertical_align: :top, align: :left
            cell_style rows[3][2], vertical_align: :top, align: :left
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][4], align: :center, vertical_align: :center
            cell_style rows[4][0], colspan: 3, align: :right, bold: true
            cell_style rows[4][1], align: :center, bold: true
            cell_style rows[4][2], align: :center, bold: true
        end

        docx.p
    end
end
