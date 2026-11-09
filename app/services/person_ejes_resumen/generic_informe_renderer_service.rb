##
# generic methods
class PersonEjesResumen::GenericInformeRendererService
    attr_reader :docx

    delegate :date_to_str,
             to: PersonEjesResumen

    def initialize(docx:, activities_by_periods_renderer_service:)
        @docx = docx
        @activities_by_periods_renderer_service = activities_by_periods_renderer_service
    end

    def generic_styles
        docx.font name: "Calibri (Cuerpo)"

        docx.page_size do
            # A4
            width   11900
            height  16840
        end

        docx.page_margins do
            left    720
            right   720
            top     720
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

    def signature
        # todo extract?
        docx.p "Atentamente. _"

        docx.p
        docx.p
        docx.p
        docx.p
        docx.p

        docx.p Rails.application.credentials.report_signed_by
    end

    def fecha_entrega
        docx.p "Fecha de entrega: #{date_to_str(Date.today)}"
    end

    def draft_activities_list
        @activities_by_periods_renderer_service.grouped_activities.each do |grouped_activities|
            grouped_activities.activities.each do |act|
                docx.p act.render_string
            end
        end
    end
end
