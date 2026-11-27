# Builds date-bounded percentage periods from a report's period details.
class PersonEjesResumen::PeriodosRendererService::PeriodosPorcentualesRenderer
    PORCENTAJES = [
        "20%",
        "40%",
        "60%",
        "80%"
    ].freeze

    # @param kind [Symbol] treatment axis used by each period wrapper
    # @param person_ejes_resumen [PersonEjesResumen] source report and period data
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    # Parses each configured date range into a percentage period wrapper.
    # @return [Array<PersonEjesResumen::PeriodosWrapper::PorcentualWrapper>]
    def periodos_porcentuales
        @periodos_porcentuales = []
        @person_ejes_resumen.periodos_detalle.split("\n").each_with_index do |periodos, index|
            percentage = PORCENTAJES.fetch(index)
            start_date, end_date = periodos.split("\t")
            @periodos_porcentuales << PersonEjesResumen::PeriodosWrapper::PorcentualWrapper.new(
                kind: @kind,
                start_date: start_date,
                end_date: end_date,
                period_percentage: percentage
            )
        end
        @periodos_porcentuales
    end
end
