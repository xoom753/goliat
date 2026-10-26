class PersonEjeResumenRenderService
    delegate :periodos_detalle,
             :semestres_porcentuales,
             :delitos_array,
             :sentencias_array,
             :acumulacion_penas,
             to: :@person_ejes_resumen

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


    def initialize(person_ejes_resumen)
        @person_ejes_resumen = person_ejes_resumen
    end

    def common_table_rows
        @common_table_rows ||= [
            [
                "Nombre:".upcase,
                @person_ejes_resumen.nombres
            ],
            [
                "Cédula de identidad:".upcase,
                @person_ejes_resumen.dni
            ],
            [
                "Fecha de pérdida de libertad:".upcase,
                date_to_str(@person_ejes_resumen.fecha_perdida_libertad)
            ]
        ] + table_rows_delitos_y_penas
    end

    def table_merged_rows_count
        rows = 3 # base
        if several_delitos?
            # because it includes acumulacion de penas
            rows += 1
        end
        rows + ( delitos_array.length * 2)
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
    def semestres_detail_hash
        return @detail_hash if @detail_hash
        @detail_hash = {}
        semestres_porcentuales_array.each_with_index do |semestre_porcentual, index|
            @detail_hash[semestre_porcentual] = semestres_array(index)
        end
        @detail_hash
    end

    private

    def several_delitos?
        delitos_array.length > 1
    end

    def table_rows_delitos_y_penas
        return @table_rows_delitos_y_penas if @table_rows_delitos_y_penas
        @table_rows_delitos_y_penas = []
        delitos_array.each_with_index do |delito, index|
            @table_rows_delitos_y_penas << [
                "Delito#{" #{index + 1}" if several_delitos?}:".upcase,
                delito
            ]
            @table_rows_delitos_y_penas << [
                "Sentencia#{" #{index + 1}" if several_delitos?}:".upcase,
                sentencias_array[index]
            ]
            if several_delitos?
                @table_rows_delitos_y_penas << [
                    "Acumulación de penas:".upcase,
                    acumulacion_penas
                ]
            end
        end
        @table_rows_delitos_y_penas
    end

    def periodos_detalles_by_semestres
        # separados por una línea en blanco
        @periodos_detalles_by_semestres ||= periodos_detalle.split("\n\n")
    end

    def semestres_array(index)
        periodos_detalles_by_semestres[index].split("\n").map do |periodo|
            start_date, end_date, _, percentage = periodo.split("\t")
            start_date = parse_date_str(start_date)
            end_date = parse_date_str(end_date)
            start_date = date_to_str(start_date)
            end_date = date_to_str(end_date)
            {
                start_date:,
                end_date:,
                percentage:,
                semestre_str: semestres_percentages[percentage]
            }
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

    def semestres_porcentuales_array
        @semestres_porcentuales_array ||= semestres_porcentuales.split("\n")
    end

    ##
    # 7,39%
    def percentage_str(number)
        parsed_number = number.sub(",", ".").to_f
        parsed_number = '%.2f' % parsed_number
        "#{parsed_number.sub(".", ",")}%"
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
    # "02/06/22" => 02/06/2022
    def parse_date_str(date)
        Date.strptime(date, "%d/%m/%y")
    end

    ##
    # 2022-06-02 => "02/06/2022"
    def date_to_str(date)
        date.strftime("%d/%m/%Y")
    end
end
