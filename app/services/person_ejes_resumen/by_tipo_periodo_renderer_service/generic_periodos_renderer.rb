class PersonEjesResumen::ByTipoPeriodoRendererService::GenericPeriodosRenderer
    KIND_SPECIFIC_TABLE_HEADER_COLSPAN_BASE = 4

    delegate :several_delitos?,
             to: :@person_ejes_resumen

    delegate :t,
             to: :@informes_translator_service

    delegate :date_to_str,
             to: PersonEjesResumen

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

    def get_info_table_merged_rows_count
        rows = 2 # base
        rows += extra_info_table_merged_rows
        rows += 1 if @person_ejes_resumen.fecha_traslado.present?
        rows += 1 if several_delitos?
        rows + (@person_ejes_resumen.delitos_array.length * 2)
    end

    def info_actividades_temporales_list
        @docx.p t("common.act_temporal").upcase, bold: true

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
        no_registra_temporal = t("common.no_registra_temporal", downcase: true, kind_f: true)
        @docx.ol do
            li no_registra_temporal
        end
    end
end
