class PersonEjesResumen::PeriodosRendererService
    PORCENTAJES = [
        "20%",
        "40%",
        "60%",
        "80%"
    ].freeze

    def initialize(person_ejes_resumen:)
        @person_ejes_resumen = person_ejes_resumen
    end

    def periodos
        if @person_ejes_resumen.tipo_porcentual?
            periodos_porcentuales
        else
            raise "todo"
        end
    end

    private

    ##
    # {
    #     "20%" => [
    #         {
    #             start_date: "15/03/2025",
    #             end_date: "13/09/2025"
    #         }
    #     ]
    # }
    def periodos_porcentuales
        return @periodos_porcentuales if @periodos_porcentuales
        @periodos_porcentuales ||= {}
        @person_ejes_resumen.periodos_detalle.split("\n").each_with_index do |periodos, index|
            percentage = PORCENTAJES.fetch(index)
            start_date, end_date = periodos.split("\t")
            @periodos_porcentuales[percentage] = [{
                start_date: start_date,
                end_date: end_date
            }]
        end
        @periodos_porcentuales
    end
end
