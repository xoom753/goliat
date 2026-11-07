class InformeRendererService::InformeDeportivoRenderer < InformeRendererService::GenericRenderer
    def ficha_qualy_main_table
        docx.h1 c_t("qualy_main_table_title").upcase, align: :center
        docx.p

        header_colspan = get_header_colspan

        docx.table qualy_table_rows do
            column_widths  [370, 1200, 110, 110, 110, 110]
            border_size 4
            cell_style cols[0], bold: true
            cell_style rows[0][0], colspan: header_colspan, align: :center
            cell_style rows[1][0], colspan: 2, align: :center
            cell_style rows[1][1], align: :center, bold: true
            cell_style rows[1][2], align: :center, bold: true
            cell_style rows[1][3], align: :center, bold: true
            cell_style rows[1][4], align: :center, bold: true
            cell_style rows[2][0], align: :center, vertical_align: :center
            cell_style rows[2][2], align: :center, vertical_align: :center
            cell_style rows[2][3], align: :center, vertical_align: :center
            cell_style rows[2][4], align: :center, vertical_align: :center
            cell_style rows[2][5], align: :center, vertical_align: :center
            cell_style rows[2][6], align: :center, vertical_align: :center
            cell_style rows[3][0], align: :center, vertical_align: :center
            cell_style rows[3][1], vertical_align: :center
            cell_style rows[3][2], align: :center, vertical_align: :center
            cell_style rows[3][3], align: :center, vertical_align: :center
            cell_style rows[3][4], align: :center, vertical_align: :center
            cell_style rows[3][5], align: :center, vertical_align: :center
            cell_style rows[3][6], align: :center, vertical_align: :center
            cell_style rows[4][0], colspan: 2, align: :right, bold: true
            cell_style rows[4][1], align: :center, bold: true
            cell_style rows[4][2], align: :center, bold: true
            cell_style rows[4][3], align: :center, bold: true
            cell_style rows[4][4], align: :center, bold: true
        end

        docx.p
    end

    private

    def get_header_colspan
        header_colspan = 4
        if tipo_porcentual?
            remaining_periods = periodos_porcentuales.keys.drop(1)
            header_colspan += remaining_periods.length
        end
        header_colspan
    end

    def qualy_table_rows
        @qualy_table_rows = [
            [
                "Deportivo".upcase
            ],
            [
                "Parámetros de Evaluación".upcase,
                "Máx".upcase,
                semestre
            ],
            [
                "Permanente".upcase,
                "Actividades deportivas, recreativas y de educación física, como: fútbol en sus diferentes modalidades, baloncesto, ecuavóley, halterofilia, caminatas, trote, tenis de mesa, ajedrez, juegos lúdicos, bailoterapia, yoga, entre otras.",
                "3",
                "0"
            ],
            [
                "Temporal".upcase,
                "Capacitaciones en materia deportiva y otras que oferte el centro de privación de libertad en coordinación con las entidades públicas y privadas.",
                "2",
                temp_grade.to_s
            ],
            [
                "Subtotal",
                "5",
                temp_grade.to_s
            ]
        ]

        if tipo_porcentual?
            remaining_periods = periodos_porcentuales.keys.drop(1)
            zeroes = 1.upto(remaining_periods.length).map{ "0" } # TODO
            @qualy_table_rows.each_with_index do |row, index|
                if index == 1
                    row.concat remaining_periods
                elsif index > 1
                    row.concat zeroes
                end
            end
        end
        @qualy_table_rows
    end

    def c_t(key, **options)
        if options[:kind_f]
            kind_str = I18n.t("common.#{kind}_f")
        else
            kind_str = I18n.t("common.#{kind}")
        end
        if options[:downcase]
            kind_str = kind_str.downcase
        end
        I18n.t("common.#{key}", **options.merge(kind_str:))
    end
end
