class ExportPersonEjesResumenesController < ApplicationController
    before_action :person_ejes_resumen_and_render, only: [
        :cultural,
        :deportivo,
        :laboral,
        :educativo,
        :social,
        :certificados,
        :certificados_educativo
    ]

    before_action :set_informe_renderer_service!, only: [
        :cultural,
        :deportivo,
        :laboral,
        :educativo,
        :social
    ]

    before_action :set_person_ejes_certificados_renderer!, only: [
        :certificados,
        :certificados_educativo
    ]

    def cultural
        filename = "Cultural-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def deportivo
        filename = "Deportivo-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def laboral
        filename = "Laboral-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def educativo
        filename = "Educativo-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def social
        filename = "Social-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def certificados
        @csv_renderer.kinds = [
            :cultural,
            :deportivo,
            :laboral
        ]
        respond_to do |format|
            format.docx {
                filename = "Certificados-#{@person_ejes_resumen.nombres}.docx"
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
            format.csv {
                csv_name = "#{@person_ejes_resumen.nombres}"
                send_data @csv_renderer.to_csv,
                          filename: "certificados-#{csv_name}.csv",
                          disposition: :attachment
            }
        end
    end

    def certificados_educativo
        @csv_renderer.kinds = [ :educativo ]
        respond_to do |format|
            format.docx {
                filename = "Certificados-#{@person_ejes_resumen.nombres}.docx"
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
            format.csv {
                csv_name = "#{@person_ejes_resumen.nombres}"
                send_data @csv_renderer.to_csv,
                          filename: "certificados-#{csv_name}.csv",
                          disposition: :attachment
            }
        end
    end

    private

    def person_ejes_resumen_and_render
        @person_ejes_resumen = PersonEjesResumen.find(params[:id])
        @person_ejes_resumen.update_last_generated_at!
    end

    def set_informe_renderer_service!
        @informe_renderer_service = ::PersonEjesResumen::InformeRendererService.new(
            kind: action_name.to_sym,
            person_ejes_resumen: @person_ejes_resumen
        )
    end

    def set_person_ejes_certificados_renderer!
        @csv_renderer = PersonEjesCertificadosRenderService.new(
            @person_ejes_resumen
        )
    end
end
