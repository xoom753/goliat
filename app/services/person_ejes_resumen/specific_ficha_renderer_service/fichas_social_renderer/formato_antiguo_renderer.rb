class PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoAntiguoRenderer
    def initialize(docx:)
        @docx = docx
    end

    def table
        table_rows = [
            [
                "Áreas".upcase,
                "Parámetros".upcase,
                "Puntuación".upcase,
                "Calificación".upcase,
                "Total por área".upcase
            ],
            [
                "Relaciones interpersonales - 2,5 puntos".upcase,
                "Asistencia a terapias individuales o grupales",
                "0,50",
                "0,50",
                "2,5"
            ],
            [
                "",
                "Buenas relaciones",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Respeto y cooperación entre los compañeros",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Cumplimiento de los horarios y reglamentos establecidos",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Comportamiento con visita, servidores públicos, PPL, y otras personas que ingresen al Centro",
                "0,50",
                "0,50",
                ""
            ]
        ]

        @docx.table table_rows do
            column_widths [ 700, 1300, 500, 500, 600 ]
            border_size 4
            cell_style rows[0], bold: true, align: :center
            cell_style cols[0], bold: true, align: :center
            cell_style cols[2], align: :center
            cell_style cols[3], align: :center, bold: true
            cell_style cols[4], align: :center

            cell_style rows[1][0], rowspan: 5, vertical_align: :center
            cell_style rows[1][4], rowspan: 5, vertical_align: :center
        end
    end
end
