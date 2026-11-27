# Adapts a current activity record to the report renderer interface.
# @see PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
# @group Activity renderers
class PersonEjesResumen::ActivityRendererService::PresentActivityRenderer < PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
    def activity_nombre
        @current_activity.coursable.nombre
    end

    def activity_human_name_d
        if @current_activity.coursable.activity_human_name.present?
            @current_activity.coursable.activity_human_name.nombre.downcase
        else
            activity_nombre.downcase
        end
    end

    def duracion_i
        get_duracion_h @current_activity.qty_h
    end

    def month
        "#{@current_activity.mes}-#{@current_activity.anio}"
    end
end
