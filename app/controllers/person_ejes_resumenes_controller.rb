class PersonEjesResumenesController < ApplicationController
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

    private

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
