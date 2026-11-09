class PersonEjesResumen::PresentActivityRendererService < PersonEjesResumen::GenericActivityRendererService
    def activity_nombre
        @current_activity.coursable.nombre
    end

    def duracion_i
        get_duracion_h @current_activity.qty_h
    end

    def month
        "#{@current_activity.mes}-#{@current_activity.anio}"
    end
end
