class PersonEjesResumen::SpecificFichaRendererService::FichasDeportivoRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    private

    def grades_table_rows_first_part
        [
            [
                "Deportivo".upcase
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
                "Actividades deportivas, recreativas y de educación física, como: fútbol en sus diferentes modalidades, baloncesto, ecuavóley, halterofilia, caminatas, trote, tenis de mesa, ajedrez, juegos lúdicos, bailoterapia, yoga, entre otras.",
                "3",
                "0"
            ]
        ]
    end

    def grades_table_rows_last_part
        [
            [
                "Temporal".upcase,
                "Capacitaciones en materia deportiva y otras que oferte el centro de privación de libertad en coordinación con las entidades públicas y privadas.",
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
