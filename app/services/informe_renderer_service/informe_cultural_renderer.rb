class InformeRendererService::InformeCulturalRenderer < InformeRendererService::GenericRenderer

    def ficha_qualy_main_table
        docx.h1 c_t("qualy_main_table_title").upcase, align: :center
        docx.p

        docx.table [
            [
                "Parámetros de Evaluación".upcase,
                "Máx".upcase,
                semestre
            ],
            [
                "Cultural".upcase,
                "Permanente".upcase,
                "Literatura, artes escénicas, música, artes plásticas y visuales, producción audiovisual y radio, comunicación, entre otras.",
                "3",
                "0"
            ],
            [
                "",
                "Temporal".upcase,
                "Charlas, concursos, talleres, capacitaciones, entre otras.",
                "2",
                "2"
            ],
            [
                "Subtotal",
                "5",
                "2"
            ]
        ] do
            column_widths  [300, 370, 1400, 110, 110]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[0][0], colspan: 3, align: :center
            cell_style rows[0][1], align: :center, bold: true
            cell_style rows[0][2], align: :center, bold: true
            cell_style rows[1][0], rowspan: 2, align: :center, vertical_align: :center
            cell_style rows[1][1], align: :center, bold: true, vertical_align: :center
            cell_style rows[1][3], align: :center, vertical_align: :center
            cell_style rows[1][4], align: :center, vertical_align: :center
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[2][1], align: :center, bold: true, vertical_align: :center
            cell_style rows[3][0], colspan: 3, align: :right, bold: true
            cell_style rows[3][1], align: :center, bold: true
            cell_style rows[3][2], align: :center, bold: true
        end

        docx.p
    end
end
