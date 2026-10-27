class InformeRendererService::GenericRenderer
    attr_accessor :period, :semestre

    delegate :docx,
             :kind,
             :person_ejes_renderer,
             to: :@informe_renderer_service

    def initialize(informe_renderer_service)
        @informe_renderer_service = informe_renderer_service
    end

    def ficha_info_title
        docx.h1 c_t("main_title").upcase, align: :center
        docx.h1 c_t("main_subtitle").upcase, align: :center
        docx.p
    end

    def ficha_info_intro
        docx.p c_t("main_intro")
        docx.p
    end

    def ficha_info_table
        info_table_merged_rows_count = person_ejes_renderer.table_merged_rows_count
        docx.table person_ejes_renderer.common_table_rows + [
            [
                "Temporalidad".upcase,
                semestre
            ],
            [
                "Semestre".upcase,
                period[:start_date],
                period[:end_date]
            ]
        ] do
            cell_style cols[0], bold: true
            0.upto(info_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end

        docx.p
    end

    def ficha_info_summary
        docx.p c_t("informe_kind").upcase, bold: true
        person_nombres = person_ejes_renderer.nombres
        se_informa = c_t("se_informa")
        desde_su_ingreso = c_t("desde_su_ingreso", kind_f: true)
        cumple_con_proceso = c_t("cumple_con_proceso", kind_f: true)
        docx.p do
            text se_informa
            text person_nombres.upcase, bold: true
            text desde_su_ingreso
            text "SÍ", bold: true
            text cumple_con_proceso
        end
        docx.p
    end

    def ficha_info_actividades
        docx.p c_t("act_permanente").upcase, bold: true

        no_registra_permanente = c_t("no_registra_permanente", downcase: true, kind_f: true)
        docx.ol do
            li no_registra_permanente
        end

        docx.p

        docx.p c_t("act_temporal").upcase, bold: true

        no_registra_temporal = c_t("no_registra_temporal", downcase: true, kind_f: true)
        docx.ol do
            li no_registra_temporal
        end

        docx.p
    end

    def ficha_info_outro
        docx.p c_t("info_outro_indico")

        docx.p

        ubicacion = person_ejes_renderer.ubicacion
        observacion = c_t("info_outro_observacion")
        reside_en = c_t("info_outro_reside_en")
        docx.p do
            text observacion, bold: true
            text " #{reside_en} #{ubicacion}"
        end

        docx.p
    end

    def encargado_title
        docx.p c_t("encargado").upcase, bold: true
    end

    def ficha_qualy_title
        docx.h1 c_t("qualy_main_title").upcase, align: :center
        docx.h1 c_t("qualy_main_subtitle", kind_f: true).upcase, align: :center
        docx.p
    end

    def ficha_qualy_intro
        docx.p c_t("qualy_datos").upcase, bold: true
        docx.p
    end

    def ficha_qualy_info_table
        qualy_table_merged_rows_count = person_ejes_renderer.table_merged_rows_count - 1
        docx.table person_ejes_renderer.common_table_rows + [
            [
                period[:semestre_str].upcase,
                period[:start_date],
                period[:end_date]
            ]
        ] do
            cell_style cols[0], bold: true
            0.upto(qualy_table_merged_rows_count).each do |row_n|
                cell_style rows[row_n][1], colspan: 2
            end
            cell_style cells, margins: { top: 10, bottom: 5, left: 100, right: 5}
        end

        docx.p
    end

    def ficha_qualy_summary
        observaciones = c_t("qualy_observaciones")
        durante_el_tiempo = c_t("qualy_durante_el_tiempo")
        cumple_con = c_t("qualy_cumple_con")
        docx.p do
            text observaciones, bold: true
            text durante_el_tiempo
            text "SÍ", bold: true
            text cumple_con
        end
        docx.p
    end

    protected

    def c_t(key, **options)
        kind_str = I18n.t("common.#{kind}")
        if options[:downcase]
            kind_str = kind_str.downcase
        end
        I18n.t("common.#{key}", **options.merge(kind_str:))
    end
end
