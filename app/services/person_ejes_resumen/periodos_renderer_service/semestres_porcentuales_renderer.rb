class PersonEjesResumen::PeriodosRendererService::SemestresPorcentualesRenderer
    SEMESTRE_NAMES = [
        "Primer semestre",
        "Segundo semestre",
        "Tercer semestre",
        "Cuarto semestre",
        "Quinto semestre",
        "Sexto semestre",
        "Séptimo semestre",
        "Octavo semestre",
        "Noveno semestre",
        "Décimo semestre",
        "Undécimo semestre",
        "Duodécimo semestre",
        "Décimo tercer semestre",
        "Décimo cuarto semestre",
    ].freeze

    delegate :date_to_str, to: PersonEjesResumen

    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def semestres_porcentuales
        # @semestres_porcentuales = {}
        # percentages.each_with_index do |semestre_porcentual, index|
        #     @semestres_porcentuales[semestre_porcentual] = semestres_array(index)
        # end
        # @semestres_porcentuales
        @semestres_porcentuales = []
        percentages.each_with_index do |semestre_porcentual, index|
            @semestres_porcentuales.concat( semestres_array(index) )
        end
        @semestres_porcentuales
    end

    private

    def percentages
        @percentages ||= @person_ejes_resumen.semestres_porcentuales.split("\n")
    end

    def periodos_detalles_by_semestres
        # separados por una línea en blanco
        @periodos_detalles_by_semestres ||= @person_ejes_resumen.periodos_detalle.split("\n\n")
    end

    def semestres_array(index)
        periodos_detalles_by_semestres[index].split("\n").map do |periodo|
            start_date, end_date, _, percentage = periodo.split("\t")
            PersonEjesResumen::PeriodosWrapper::SemestralWrapper.new(
                kind: @kind,
                start_date:,
                end_date:,
                percentage:,
                semestre_str: semestres_percentages.fetch(percentage),
                period_percentage: percentages[index]
            )
        end
    end

    def semestres_percentages
        return @semestres_percentages if @semestres_percentages
        @semestres_percentages = {}
        semestre_name_idx = 0
        last_percentage = "0"
        periodos_detalles_by_semestres.each do |semestres|
            semestres.split("\n").each do |periodo|
                _, _, _, percentage = periodo.split("\t")
                semestre_name = SEMESTRE_NAMES.fetch(semestre_name_idx)
                @semestres_percentages[percentage] = "#{semestre_name} #{percentage_str(last_percentage)} al #{percentage}"
                last_percentage = add_point_one_to_p(percentage)
                semestre_name_idx += 1
            end
            semestre_name_idx = 0
        end
        @semestres_percentages
    end

    ##
    # 7,39% => 7,40%
    def add_point_one_to_p(number)
        parsed_number = number.sub(",", ".").to_f
        parsed_number += 0.01
        parsed_number = '%.2f' % parsed_number
        "#{parsed_number.sub(".", ",")}%"
    end

    ##
    # 7,39%
    def percentage_str(number)
        parsed_number = number.sub(",", ".").to_f
        parsed_number = '%.2f' % parsed_number
        "#{parsed_number.sub(".", ",")}%"
    end
end
