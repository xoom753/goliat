class PersonEjesResumen::ActivityToHumanRendererService
    def initialize(
            kind:,
            activities:,
            duracion_i:,
            by_months:
        )
        # @activities = activities
        @kind = kind
        @duracion_i = duracion_i
        @by_months = by_months
    end

    def to_string
        I18n.t(
            "certs.to_h.#{by_months_identifier}.#{activity_kind_identifier.genre}",
            actividad_str: activity_str,
            duracion_str: duracion_str,
            meses_y_anios_str: meses_y_anios_str,
            actividad_kind: actividad_kind
        )
    end

    private

    def actividad_kind
        I18n.t(
            "certs.activity_kind.#{activity_kind_identifier.identifier_str}"
        )
    end

    def duracion_str
        "#{@duracion_i} horas"
    end

    def by_months_identifier
        if @by_months.keys.length > 1
            :several_months
        else
            :one_month
        end
    end

    def activity_kind_identifier
        @activity_kind_identifier ||= PersonEjesResumen::ActivityToHumanRendererService::ActivityKindIdentifier.new(
            activity_str: activity_str,
            kind: @kind
        )
    end

    def meses_y_anios_str
        PersonEjesResumen::ActivityToHumanRendererService::ActivityMonthsAndYearsRenderer.new(
            by_months: @by_months
        ).meses_y_anios_str
    end

    def activity_str
        @activity_str ||= PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer.new(
            actividad_str: @by_months.values.first.activity_nombre
        ).activity_str
    end
end
