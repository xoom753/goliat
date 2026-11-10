class PersonEjesResumen::FichasCulturalRendererService
    attr_reader :docx

    delegate :periodos,
             to: :@periodos_renderer_service

    def initialize(
        docx:,
        person_ejes_resumen:,
        periodos_renderer_service:,
        current_periodo:
    )
        @docx = docx
        @current_periodo = current_periodo
        @person_ejes_resumen = person_ejes_resumen
        @periodos_renderer_service = periodos_renderer_service
    end

    def grades_table
        header_colspan = get_header_colspan
        docx.table grades_table_rows do
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

    def temp_grade
        if @current_periodo.activities.empty?
            "0"
        else
            "2"
        end
    end

    def get_header_colspan
        header_colspan = 4
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

        concat_tipo_porcentual_rows!(@grades_table_rows) if @person_ejes_resumen.tipo_porcentual?

        @grades_table_rows
    end

    def concat_tipo_porcentual_rows!(table_rows)
        remaining_periods = periodos.drop(1)
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
            elsif index > 1
                row.concat grades
            end
        end
    end
end
