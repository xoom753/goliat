class InformeRendererService
    attr_accessor :docx, :kind
    attr_reader :person_ejes_renderer

    delegate :period=,
             :semestre=,
             :ficha_info_title,
             :ficha_info_intro,
             :ficha_info_table,
             :ficha_info_summary,
             :ficha_info_actividades,
             :ficha_info_outro,
             :encargado_title,
             :ficha_qualy_title,
             :ficha_qualy_intro,
             :ficha_qualy_info_table,
             :ficha_qualy_main_table,
             :ficha_qualy_summary,
             to: :specific_renderer

    def initialize(person_ejes_resumen_renderer_service)
        @person_ejes_renderer = person_ejes_resumen_renderer_service
    end

    def header
        docx.header do
            img "vendor/images/gdec.png", width: 120, height: 50, align: :left
            img "vendor/images/snai.png", width: 310, height: 85, align: :right
        end
    end

    def footer
        docx.footer do
            img "vendor/images/snaifoot.png", width: 218, height: 69
        end
    end

    def generic_styles
        docx.font name: "Calibri (Cuerpo)"

        docx.page_margins do
        left    1440
        right   1440
        top     360
        bottom  720
        end

        docx.style do
            id "Heading1"
            name "Heading1"
            font "Calibri (Cuerpo)"
            size 20
            bold true
        end

        docx.style do
            id "Normal"
            name "Normal"
            font "Calibri (Cuerpo)"
            size 20
            align :both
            line 240
        end

        docx.style do
            id "TableNormal"
            name "TableNormal"
            font "Calibri (Cuerpo)"
            size 20
            align :both
        end
    end

    def signature
        docx.p "Atentamente. _"

        docx.p
        docx.p
        docx.p
        docx.p
        docx.p

        docx.p "Víctor Hugo Suárez Mejía"
    end

    def fecha_entrega
        docx.p "Fecha de entrega: #{Date.today.strftime('%d/%m/%Y')}"
    end

    private

    def specific_renderer
        @specific_renderer ||= "InformeRendererService::Informe#{kind.to_s.classify}Renderer".constantize.new(
            self
        )
    end
end
