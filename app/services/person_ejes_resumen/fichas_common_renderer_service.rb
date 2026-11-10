class PersonEjesResumen::FichasCommonRendererService
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

    protected

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
