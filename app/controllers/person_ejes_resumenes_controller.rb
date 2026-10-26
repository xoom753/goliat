class PersonEjesResumenesController < ApplicationController
    before_action :person_ejes_resumen_and_render, only: [
        :cultural,
        :deportivo,
        :laboral
    ]

    def index
        @person_ejes_resumenes = PersonEjesResumen.all
    end

    def new
        @person_ejes_resumen = PersonEjesResumen.new
    end

    def create
        @person_ejes_resumen = PersonEjesResumen.new(person_ejes_resumen_params)
        if @person_ejes_resumen.save
            redirect_to action: :index
        else
            render :new
        end
    end

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

    private

    def person_ejes_resumen_and_render
        @person_ejes_resumen = PersonEjesResumen.find(params[:id])
        @render_service = PersonEjeResumenRenderService.new(
            @person_ejes_resumen
        )
    end

    def person_ejes_resumen_params
        params.require(:person_ejes_resumen).permit(
            :nombres,
            :dni,
            :fecha_perdida_libertad,
            :delitos,
            :sentencias,
            :acumulacion_penas,
            :semestres_porcentuales,
            :periodos_detalle,
            :ubicacion
        )
    end
end
