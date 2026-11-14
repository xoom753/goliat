class PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    delegate :t,
             to: I18n

    def grades_table
        if @current_periodo.is_formato_antiguo?
            formato_antiguo_table
        else
            formato_actual_table
        end
    end

    private

    def formato_antiguo_table
        table_rows = [
            [
                "Áreas".upcase,
                "Parámetros".upcase,
                "Puntuación".upcase,
                "Calificación".upcase,
                "Total por área".upcase
            ],
            [
                "Relaciones interpersonales - 2,5 puntos".upcase,
                "Asistencia a terapias individuales o grupales",
                "0,50",
                "0,50",
                "2,5"
            ],
            [
                "",
                "Buenas relaciones",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Respeto y cooperación entre los compañeros",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Cumplimiento de los horarios y reglamentos establecidos",
                "0,50",
                "0,50",
                ""
            ],
            [
                "",
                "Comportamiento con visita, servidores públicos, PPL, y otras personas que ingresen al Centro",
                "0,50",
                "0,50",
                ""
            ]
        ]

        docx.table table_rows do
            column_widths [700, 1300, 500, 500, 600]
            border_size 4
            cell_style rows[0], bold: true, align: :center
            cell_style cols[0], bold: true, align: :center
            cell_style cols[2], align: :center
            cell_style cols[3], align: :center, bold: true
            cell_style cols[4], align: :center

            cell_style rows[1][0], rowspan: 5, vertical_align: :center
            cell_style rows[1][4], rowspan: 5, vertical_align: :center
        end
    end

    def formato_actual_table
        table_rows = [
            [
                "Actividades".upcase,
                "Detalles de actividades".upcase,
                "Puntaje".upcase,
                get_semestre,
                "Justificación de la calificación".upcase
            ],
            [
                t("person_ejes_resumen.social_report.permanente_disciplina"),
                t("person_ejes_resumen.social_report.permanente_respeto"),
                "0,50 puntos",
                "0,50",
                "Sí cumple"
            ],
            [
                t("person_ejes_resumen.social_report.permanente_disciplina"),
                t("person_ejes_resumen.social_report.permanente_comportamiento"),
                "0,50 puntos",
                "0,50",
                "Sí cumple"
            ],
            [
                t("person_ejes_resumen.social_report.temporal_capacitaciones"),
                t("person_ejes_resumen.social_report.temporal_participacion"),
                @person_ejes_resumen.tipo_porcentual? ? "0,50 puntos" : "2 puntos",
                @person_ejes_resumen.tipo_porcentual? ? "0,50" : "1",
                "Charlas motivacionales individuales"
            ],
            [
                t("person_ejes_resumen.social_report.permanente_apoyo"),
                t("person_ejes_resumen.social_report.permanente_participacion"),
                @person_ejes_resumen.tipo_porcentual? ? "0,50 puntos" : "2 puntos",
                @person_ejes_resumen.tipo_porcentual? ? "0,50" : "1",
                "Orientaciones psicológicas grupales"
            ]
        ]

        docx.table table_rows do
            column_widths [700, 1300, 500, 500, 600]
            border_size 4
            cell_style rows[0], bold: true, align: :center
            cell_style cols[2], align: :center
            cell_style cols[3], align: :center
        end
    end
end
