# Adapts a historical activity record to the report renderer interface.
# @see PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
# @group Activity renderers
class PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer < PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
    def activity_nombre
        @current_activity.legacy_activity.nombre
    end

    def activity_human_name_d
        activity_nombre.downcase
    end

    def duracion_i
        get_duracion_h @current_activity.duracion
    end

    def month
        @current_activity.end_date.strftime "%m-%Y"
    end
end
