require "csv"

# Collects treatment-axis activities and exports them as certificate CSV rows.
class PersonEjesCertificadosRenderService
    attr_accessor :kinds

    # @param person_ejes_resumen [PersonEjesResumen] report supplying the person's name and activities
    def initialize(person_ejes_resumen)
        @person_ejes_resumen = person_ejes_resumen
    end

    # Serializes configured activities into a CSV with a header row.
    # @return [String] CSV document
    def to_csv
        CSV.generate(headers: true) do |csv|
            csv << [ "N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas" ]
            activities.each_with_index do |activity, index|
                csv << [
                    index + 1,
                    @person_ejes_resumen.nombres,
                    activity.actividad_kind.capitalize,
                    activity.activity_str,
                    I18n.t("common.#{activity.kind}").upcase,
                    activity.meses_y_anios_str(upcase: true),
                    activity.duracion_str
                ]
            end
        end
    end

    # Returns configured activities in the configured treatment-axis order.
    # @return [Array] flattened activity renderers
    def activities
        kinds.map do |kind|
            informe_renderer_service = get_informe_renderer_service(kind)
            activities_by_periods_renderer_service = informe_renderer_service.send(:activities_by_periods_renderer_service)
            activities_by_periods_renderer_service.grouped_activities.map do |grouped_activities|
                grouped_activities.activities
            end.flatten
        end.flatten
    end

    private

    def get_informe_renderer_service(kind)
        ::PersonEjesResumen::InformeRendererService.new(
            kind: kind,
            person_ejes_resumen: @person_ejes_resumen
        )
    end
end
