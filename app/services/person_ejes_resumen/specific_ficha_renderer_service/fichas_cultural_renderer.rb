class PersonEjesResumen::SpecificFichaRendererService::FichasCulturalRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    private

    def grades_table_rows_first_part
        [
            [
                "Cultural".upcase
            ],
            [
                "Parámetros de Evaluación".upcase,
                "Máx".upcase,
                get_semestre
            ]
        ]
    end

    def grades_table_permanente_rows
        [
            [
                "Permanente".upcase,
                "Literatura, artes escénicas, música, artes plásticas y visuales, producción audiovisual y radio, comunicación, entre otras.",
                "3",
                "0"
            ]
        ]
    end

    def grades_table_rows_last_part
        [
            [
                "Temporal".upcase,
                "Charlas, concursos, talleres, capacitaciones, entre otras.",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                get_subtotal_max_grade,
                temp_grade.to_s
            ]
        ]
    end
end
