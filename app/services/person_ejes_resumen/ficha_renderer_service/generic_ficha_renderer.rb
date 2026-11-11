class PersonEjesResumen::FichaRendererService::GenericFichaRenderer
    attr_reader :docx

    delegate :date_to_str,
             to: PersonEjesResumen

    delegate :t,
             to: :@informes_translator_service

    delegate :delitos_array,
             :sentencias_array,
             :tipo_porcentual?,
             :several_delitos?,
             :acumulacion_penas,
             to: :@person_ejes_resumen

    delegate :periodos,
             to: :@periodos_renderer_service

    def initialize(
        docx:,
        kind:,
        person_ejes_resumen:,
        informes_translator_service:,
        periodos_renderer_service:,
        activities_by_periods_renderer_service:,
        index:
    )
        @docx = docx
        @kind = kind
        @index = index
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
        @periodos_renderer_service = periodos_renderer_service
        @activities_by_periods_renderer_service = activities_by_periods_renderer_service
    end

    def encargado_title
        docx.p t("common.encargado").upcase, bold: true
    end

    protected

    def current_periodo
        @periodos_renderer_service.periodos.fetch(@index)
    end

    def specific_renderer
        @specific_renderer ||= "::PersonEjesResumen::SpecificFichaRendererService::Fichas#{@kind.to_s.titleize}Renderer".constantize.new(
            person_ejes_resumen: @person_ejes_resumen,
            periodos_renderer_service: @periodos_renderer_service,
            docx: @docx,
            current_periodo: current_periodo
        )
    end

    def common_table_rows
        return @common_table_rows if @common_table_rows

        @common_table_rows = [
            [
                "Nombre:".upcase,
                @person_ejes_resumen.nombres.upcase
            ],
            [
                "Cédula de identidad:".upcase,
                @person_ejes_resumen.dni
            ],
            [
                "Fecha de pérdida de libertad:".upcase,
                date_to_str(@person_ejes_resumen.fecha_perdida_libertad)
            ]
        ]

        if @person_ejes_resumen.fecha_traslado.present?
            ubicacion_traslado_str = @person_ejes_resumen.ubicacion_traslado.present? ? " #{@person_ejes_resumen.ubicacion_traslado}" : nil
            @common_table_rows += [
                [
                    "Fecha de traslado#{ubicacion_traslado_str}:".upcase,
                    date_to_str(@person_ejes_resumen.fecha_traslado)
                ]
            ]
        end

        @common_table_rows += table_rows_delitos_y_penas
    end

    def get_info_table_merged_rows_count
        rows = 2 # base
        rows += 1 unless tipo_porcentual?
        rows += 1 if @person_ejes_resumen.fecha_traslado.present?
        rows += 1 if several_delitos?
        rows + (@person_ejes_resumen.delitos_array.length * 2)
    end

    def last_delito?(index)
        delitos_array.length <= index + 1
    end

    def table_rows_delitos_y_penas
        return @table_rows_delitos_y_penas if @table_rows_delitos_y_penas

        @table_rows_delitos_y_penas = []
        delitos_array.each_with_index do |delito, index|
            @table_rows_delitos_y_penas << [
                "Delito#{" #{index + 1}" if several_delitos?}:".upcase,
                delito
            ]
            @table_rows_delitos_y_penas << [
                "Sentencia#{" #{index + 1}" if several_delitos?}:".upcase,
                sentencias_array[index]
            ]
            if several_delitos? && last_delito?(index)
                @table_rows_delitos_y_penas << [
                    "Acumulación de penas:".upcase,
                    acumulacion_penas
                ]
            end
        end
        @table_rows_delitos_y_penas
    end

    def summary_renderer
        @summary_renderer ||= ::PersonEjesResumen::FichaRendererService::SummaryRenderer.new(
            docx: docx,
            person_ejes_resumen: @person_ejes_resumen,
            informes_translator_service: @informes_translator_service
        )
    end
end
