class PersonEjesResumenesController < ApplicationController
    before_action :person_ejes_resumen_and_render, only: [
        :cultural,
        :deportivo,
        :laboral,
        :educativo,
        :certificados
    ]

    before_action :set_informe_renderer_service!, only: [
        :cultural,
        :deportivo,
        :laboral,
        :educativo,
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
            @person_ejes_resumen.legacy_people_ids = [ params[:legacy_person_id] ]
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

    def edit
        @person_ejes_resumen = PersonEjesResumen.find(params[:id])
    end

    def update
        @person_ejes_resumen = PersonEjesResumen.find(params[:id])
        @person_ejes_resumen.assign_attributes(person_ejes_resumen_params)
        if person_ejes_resumen_params[:people_ids].blank?
            @person_ejes_resumen.people_ids = []
        end
        if person_ejes_resumen_params[:legacy_people_ids].blank?
            @person_ejes_resumen.legacy_people_ids = []
        end
        if @person_ejes_resumen.save
            redirect_to person_ejes_resumenes_path, notice: "Actualizado"
        else
            flash.now[:error] = "Algo salió mal"
            render :edit
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

    def educativo
        filename = "Educativo-#{@person_ejes_resumen.nombres}.docx"
        respond_to do |format|
            format.docx {
                headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
            }
        end
    end

    def certificados
        @csv_renderer = PersonEjesCertificadosRenderService.new(
            @person_ejes_resumen
        )
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
            :tipo_porcentual,
            people_ids: [],
            legacy_people_ids: []
        )
    end
end
