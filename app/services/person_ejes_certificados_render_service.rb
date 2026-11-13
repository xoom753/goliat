require "csv"

class PersonEjesCertificadosRenderService
    attr_accessor :kinds

    def initialize(person_ejes_resumen)
        @person_ejes_resumen = person_ejes_resumen
    end

    def to_csv
        CSV.generate(headers: true) do |csv|
            csv << ["N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"]
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
