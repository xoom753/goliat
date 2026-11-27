# Provides shared duration handling for current and historical activity renderers.
# @abstract Subclass this renderer for each activity source.
# @group Activity renderers
class PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
    delegate :end_date, to: :@current_activity

    attr_reader :duracion_i

    # @param current_activity [Object] activity record being rendered
    def initialize(current_activity:)
        @current_activity = current_activity
    end

    protected

    # Parses a stored duration string as hours.
    # @param duracion_h [String, Numeric, nil] source duration
    # @return [Numeric] parsed hours, or zero when the value is blank
    def get_duracion_h(duracion_h)
        return 30 if duracion_h.nil? # default
        duracion_h.downcase.sub("horas", "").to_i
    end
end
