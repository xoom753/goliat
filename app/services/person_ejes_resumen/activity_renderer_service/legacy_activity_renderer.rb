# Adapts a historical activity record to the report renderer interface.
# @see PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
# @group Activity renderers
class PersonEjesResumen::ActivityRendererService::LegacyActivityRenderer < PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
    delegate :legacy_activity_detail,
             to: :@current_activity

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

    def activity_detail_str
        if should_render_detail? && legacy_activity_detail.present?
            " #{legacy_activity_detail.nombre.titleize}"
        end
    end

    private

    def should_render_detail?
        activity_human_name_d == "curso"
    end
end
