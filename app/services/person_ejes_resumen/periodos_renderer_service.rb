class PersonEjesResumen::PeriodosRendererService
    def initialize(person_ejes_resumen:, kind:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def periodos
        if @person_ejes_resumen.tipo_porcentual?
            periodos_porcentuales
        else
            semestres_porcentuales
        end
    end

    def grouped_activities
        periodos.map do |percentage, periods|
            periods.map do |period|
                period
            end
        end
    end

    private

    ##
    # {
    #     "20%" => [
    #         PeriodoWrapper({
    #             start_date: "15/03/2025",
    #             end_date: "13/09/2025"
    #         })
    #     ]
    # }
    def periodos_porcentuales
        @periodos_porcentuales ||= ::PersonEjesResumen::PeriodosRendererService::PeriodosPorcentualesRenderer.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).periodos_porcentuales
    end

    ##
    # {"20%" =>
    #   [{start_date: "02/06/22", end_date: "29/11/22", percentage: "7,39%"},
    #    {start_date: "30/11/22", end_date: "29/05/23", percentage: "14,77%"},
    #    {start_date: "30/05/23", end_date: "02/10/23", percentage: "20,00%"}],
    #  "40%" =>
    #   [{start_date: "03/10/23", end_date: "31/03/24", percentage: "27,29%"},
    #    {start_date: "01/04/24", end_date: "28/09/24", percentage: "34,67%"},
    #    {start_date: "29/09/24", end_date: "31/01/25", percentage: "40,00%"}],
    #  "60%" =>
    #   [{start_date: "01/02/25", end_date: "31/07/25", percentage: "47,13%"},
    #    {start_date: "01/08/25", end_date: "28/01/26", percentage: "54,52%"},
    #    {start_date: "29/01/26", end_date: "03/06/26", percentage: "60,00%"}]}
    def semestres_porcentuales
        @semestres_porcentuales ||= ::PersonEjesResumen::PeriodosRendererService::SemestresPorcentualesRenderer.new(
            kind: @kind,
            person_ejes_resumen: @person_ejes_resumen
        ).semestres_porcentuales
    end
end
