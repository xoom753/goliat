require "csv"

class PersonEjesCertificadosRenderService
    delegate :person_ejes_renderer,
             to: :@informe_renderer_service

    def initialize(informe_renderer_service)
        @informe_renderer_service = informe_renderer_service
    end

    def to_csv
        # binding.pry
        CSV.generate(headers: true) do |csv|
            csv << ["N", "Apellidos y nombres", "Tipo curso", "Nombre curso", "Eje tratamiento", "Mes", "Horas"]
            activities.each_with_index do |activity, index|
                csv << [
                    index + 1,
                    person_ejes_renderer.nombres,
                    activity.activity_kind_str.capitalize,
                    activity.actividad_str,
                    I18n.t("common.#{activity.kind}").upcase,
                    activity.get_months_and_year(upcase: true),
                    activity.duracion
                ]
            end
        end
    end

    private

    def activities
        kinds = [
            :cultural,
            :deportivo,
            :laboral
        ]
        if @informe_renderer_service.tipo_porcentual?
            first_period = @informe_renderer_service.get_first_period
            kinds.map do |kind|
                @informe_renderer_service.kind = kind
                @informe_renderer_service.period = first_period
                @informe_renderer_service.get_activities_within_period.to_a
            end.flatten
        else
            kinds.map do |kind|
                @informe_renderer_service.kind = kind
                @informe_renderer_service.semestres_detail_hash.inject([]) do |memo, (semestre, periods)|
                    periods.each do |period|
                        @informe_renderer_service.period = period
                        memo += @informe_renderer_service.get_activities_within_period
                    end
                    memo
                end
            end.flatten
        end
    end
end
