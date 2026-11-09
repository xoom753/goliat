class PersonEjesResumen::PeriodosPorcentualesRendererService
    PORCENTAJES = [
        "20%",
        "40%",
        "60%",
        "80%"
    ].freeze

    def initialize(person_ejes_resumen:)
        @person_ejes_resumen = person_ejes_resumen
    end

    def periodos_porcentuales
        # @periodos_porcentuales = {}
        # @person_ejes_resumen.periodos_detalle.split("\n").each_with_index do |periodos, index|
        #     percentage = PORCENTAJES.fetch(index)
        #     start_date, end_date = periodos.split("\t")
        #     @periodos_porcentuales[percentage] = [
        #         PersonEjesResumen::PeriodoPorcentualWrapper.new(
        #             start_date: start_date,
        #             end_date: end_date
        #         )
        #     ]
        # end
        @periodos_porcentuales = []
        @person_ejes_resumen.periodos_detalle.split("\n").each_with_index do |periodos, index|
            percentage = PORCENTAJES.fetch(index)
            start_date, end_date = periodos.split("\t")
            @periodos_porcentuales << PersonEjesResumen::PeriodoPorcentualWrapper.new(
                start_date: start_date,
                end_date: end_date,
                period_percentage: percentage
            )
        end
        @periodos_porcentuales
    end
end
