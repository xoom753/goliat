class PersonEjesResumen::LegacyActivityRendererService < PersonEjesResumen::GenericActivityRendererService
    def activity_nombre
        @current_activity.legacy_activity.nombre
    end

    def duracion_i
        get_duracion_h @current_activity.duracion
    end

    def month
        @current_activity.end_date.strftime "%m-%Y"
    end
end
