class InformeRendererService::InformeCulturalRenderer < InformeRendererService::GenericRenderer
    def ficha_qualy_main_table
        docx.h1 c_t("qualy_main_table_title").upcase, align: :center
        docx.p

        header_colspan = get_header_colspan

        docx.table qualy_table_rows do
            column_widths  [370, 1400, 110, 90, 90, 90]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], colspan: 2, align: :center
            cell_style rows[1][1], align: :center, bold: true
            cell_style rows[1][2], align: :center, bold: true
            cell_style rows[1][3], align: :center, bold: true
            cell_style rows[1][4], align: :center, bold: true
            cell_style rows[2][0], align: :center, bold: true, vertical_align: :center
            cell_style rows[2][2], align: :center, vertical_align: :center
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[2][5], align: :center, vertical_align: :center
            cell_style rows[3][0], align: :center, vertical_align: :center
            cell_style rows[3][2], align: :center, vertical_align: :center
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][4], align: :center, vertical_align: :center
            cell_style rows[3][5], align: :center, vertical_align: :center
            cell_style rows[4][0], colspan: 2, align: :right, bold: true
            cell_style rows[4][1], align: :center, bold: true
            cell_style rows[4][2], align: :center, bold: true
            cell_style rows[4][3], align: :center, bold: true
            cell_style rows[4][4], align: :center, bold: true
        end

        docx.p
    end

    private

    def qualy_table_rows
        @qualy_table_rows = [
            [
                "Cultural".upcase
            ],
            [
                "Parámetros de Evaluación".upcase,
                "Máx".upcase,
                semestre
            ],
            [
                "Permanente".upcase,
                "Literatura, artes escénicas, música, artes plásticas y visuales, producción audiovisual y radio, comunicación, entre otras.",
                "3",
                "0"
            ],
            [
                "Temporal".upcase,
                "Charlas, concursos, talleres, capacitaciones, entre otras.",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                "5",
                temp_grade.to_s
            ]
        ]

        concat_tipo_porcentual_rows!(@qualy_table_rows) if tipo_porcentual?

        @qualy_table_rows
    end
end
