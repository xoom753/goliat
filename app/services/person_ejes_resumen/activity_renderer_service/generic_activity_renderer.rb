class PersonEjesResumen::ActivityRendererService::GenericActivityRenderer
    delegate :end_date, to: :@current_activity

    attr_reader :duracion_i

    def initialize(current_activity:)
        @current_activity = current_activity
    end

    protected

    def get_duracion_h(duracion_h)
        return 30 if duracion_h.nil? # default
        duracion_h.downcase.sub("horas", "").to_i
    end
end
