class PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    attr_reader :docx

    delegate :tipo_porcentual?,
             to: :@person_ejes_resumen

    delegate :periodos,
             to: :@periodos_renderer_service

    delegate :get_semestre,
             :get_subtotal_max_grade,
             :concat_tipo_porcentual_rows!,
             to: :@by_tipo_periodo_renderer

    def initialize(
        docx:,
        current_periodo:,
        person_ejes_resumen:,
        periodos_renderer_service:,
        by_tipo_periodo_renderer:
    )
        @docx = docx
        @current_periodo = current_periodo
        @person_ejes_resumen = person_ejes_resumen
        @periodos_renderer_service = periodos_renderer_service
        @by_tipo_periodo_renderer = by_tipo_periodo_renderer
    end

    def grades_table
        header_colspan = get_kind_specific_table_header_colspan
        column_widths = [370, 1400, 110, 90, 90, 90]

        permanente_row = 2
        temporal_row = tipo_porcentual? ? 2 : 3

        tipo_porcentual = tipo_porcentual?

        docx.table grades_table_rows do
            column_widths column_widths
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], colspan: 2, align: :center
            cell_style rows[1][1], align: :center, bold: true
            cell_style rows[1][2], align: :center, bold: true
            cell_style rows[1][3], align: :center, bold: true
            cell_style rows[1][4], align: :center, bold: true

            unless tipo_porcentual
                cell_style rows[permanente_row][0], align: :center, bold: true, vertical_align: :center
                cell_style rows[permanente_row][2], align: :center, vertical_align: :center
                cell_style rows[permanente_row][3], align: :center, vertical_align: :center
                cell_style rows[permanente_row][4], align: :center, vertical_align: :center
                cell_style rows[permanente_row][5], align: :center, vertical_align: :center
                cell_style rows[permanente_row][6], align: :center, vertical_align: :center
                cell_style rows[permanente_row][7], align: :center, vertical_align: :center
            end

            cell_style rows[temporal_row][0], align: :center, vertical_align: :center
            # cell_style rows[temporal_row][1], vertical_align: :center
            cell_style rows[temporal_row][2], align: :center, vertical_align: :center
            cell_style rows[temporal_row][3], align: :center, vertical_align: :center
            cell_style rows[temporal_row][4], align: :center, vertical_align: :center
            cell_style rows[temporal_row][5], align: :center, vertical_align: :center
            cell_style rows[temporal_row][6], align: :center, vertical_align: :center
            cell_style rows[temporal_row][7], align: :center, vertical_align: :center

            cell_style rows[temporal_row + 1][0], colspan: 2, align: :right, bold: true
            cell_style rows[temporal_row + 1][1], align: :center, bold: true
            cell_style rows[temporal_row + 1][2], align: :center, bold: true
            cell_style rows[temporal_row + 1][3], align: :center, bold: true
            cell_style rows[temporal_row + 1][4], align: :center, bold: true
            cell_style rows[temporal_row + 1][5], align: :center, bold: true
        end

        docx.p
    end

    protected

    def get_kind_specific_table_header_colspan
        # is overriden by laboral
        @by_tipo_periodo_renderer.get_kind_specific_table_header_colspan
    end

    def temp_grade
        if @current_periodo.activities.empty?
            "0"
        else
            "2"
        end
    end

    def grades_table_rows
        rows = grades_table_rows_first_part
        rows += grades_table_permanente_rows unless tipo_porcentual?
        rows += grades_table_rows_last_part

        concat_tipo_porcentual_rows!(rows) if tipo_porcentual?

        rows
    end
end
