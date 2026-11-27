# Shares report-summary and temporal-activity rendering across period formats.
class PersonEjesResumen::ByTipoPeriodoRendererService::GenericPeriodosRenderer
    KIND_SPECIFIC_TABLE_HEADER_COLSPAN_BASE = 4

    delegate :several_delitos?,
             to: :@person_ejes_resumen

    delegate :stringify,
             to: :@informes_translator_service

    delegate :date_to_str,
             to: PersonEjesResumen

    # @param docx [Object] document being rendered
    # @param periodos [Array] periods included in the report
    # @param current_periodo [Object] period associated with this ficha
    # @param person_ejes_resumen [PersonEjesResumen] report data
    # @param informes_translator_service [Object] report translation adapter
    # @param activities_by_periods_renderer_service [Object] grouped activity provider
    def initialize(
            docx:,
            periodos:,
            current_periodo:,
            person_ejes_resumen:,
            informes_translator_service:,
            activities_by_periods_renderer_service:
        )
        @docx = docx
        @periodos = periodos
        @current_periodo = current_periodo
        @person_ejes_resumen = person_ejes_resumen
        @informes_translator_service = informes_translator_service
        @activities_by_periods_renderer_service = activities_by_periods_renderer_service
    end

    # Returns the number of common and period-specific rows requiring merged cells.
    # @return [Integer]
    def get_info_table_merged_rows_count
        rows = 2 # base
        rows += extra_info_table_merged_rows
        rows += 1 if @person_ejes_resumen.fecha_traslado.present?
        rows += 1 if several_delitos?
        if @person_ejes_resumen.fechas_ingresos_y_egresos.present?
            rows += (@person_ejes_resumen.fechas_ingresos_y_egresos_array.length - 1)
        end
        rows + (@person_ejes_resumen.delitos_array.length * 2)
    end

    # Renders the temporal activity list or its empty-state message.
    # @return [void]
    def info_actividades_temporales_list
        @docx.p stringify("common.act_temporal").upcase, bold: true

        activities = get_activities

        if activities.empty?
            no_registra_actividades_temporales
        else
            @docx.ol do
                activities.each do |activity|
                    li "#{activity.render_string}."
                end
            end
        end
        @docx.p
    end

    protected

    def no_registra_actividades_temporales
        no_registra_temporal = stringify("common.no_registra_temporal", downcase: true, kind_f: true)
        @docx.ol do
            li no_registra_temporal
        end
    end
end
