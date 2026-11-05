class PersonEjesResumenesController < ApplicationController
    before_action :person_ejes_resumen_and_render, only: [
        :cultural,
        :deportivo,
        :laboral,
        :certificados
    ]

    def index
        @person_ejes_resumenes =
            PersonEjesResumen.all
                             .order(last_generated_at: :desc, id: :desc)
                             .page(params[:page])
                             .per(6)
    end

    def new
        @person_ejes_resumen = PersonEjesResumen.new
        if params[:legacy_person_id].present?
            @legacy_person = LegacyPerson.find(params[:legacy_person_id])
            @person_data_service = PersonDataService.new(
                @legacy_person
            )
            @person_ejes_resumen.nombres = @legacy_person.nombres
            @person_ejes_resumen.dni = @person_data_service.dni
            @person_ejes_resumen.ubicacion = @person_data_service.ubicacion
            @person_ejes_resumen.fecha_perdida_libertad = @person_data_service.fecha_detencion
        end
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

    def certificados
        csv_data = PersonEjesCertificadosRenderService.new(
            @informe_renderer_service
        ).to_csv
        csv_name = "#{@person_ejes_resumen.nombres}"
        send_data csv_data,
                  filename: "certificados-#{csv_name}.csv",
                  disposition: :attachment
    end

    private

    def person_ejes_resumen_and_render
        @person_ejes_resumen = PersonEjesResumen.find(params[:id])
        # update last_generated_at!
        @person_ejes_resumen.update_last_generated_at!
        @render_service = PersonEjeResumenRenderService.new(
            @person_ejes_resumen
        )
        @informe_renderer_service = InformeRendererService.new(
            @render_service
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
            :ubicacion,
            :fecha_traslado,
            :ubicacion_traslado,
            :tipo_porcentual
        )
    end
end
