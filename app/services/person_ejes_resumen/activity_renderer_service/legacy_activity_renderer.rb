class PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer < PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
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
