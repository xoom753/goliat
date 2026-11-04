class LegacyPeopleActivitiesRendererService::GroupedActivitiesCertRenderer < LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
    def initialize(person_activities:)
        @person_activities = person_activities
        @kind = @person_activities.first.kind
        @year = @person_activities.first.year
        @duracion = get_duracion
    end

    def get_months_and_year(upcase: false)
        last_activity = @person_activities.last
        first_part_activities = @person_activities[0...-1]
        first_part_str = first_part_activities.map do |activity|
            mes = MESES.fetch(activity.month - 1)
            upcase ? mes.upcase : mes
        end.join(", ")
        last_month = MESES.fetch(last_activity.month - 1)
        last_month = last_month.upcase if upcase
        [
            first_part_str, last_month
        ].join(" y ") + " de #{@year}"
    end

    def actividad_str
        @person_activities.first.actividad_str
    end

    def activity_kind_str
        I18n.t(
            "certs.activity_kind.#{activity_kind_identifier}"
        )
    end

    private

    def certs_prefix
        "grouped_certs"
    end

    def get_duracion
        horas = @person_activities.inject(0) do |memo, person_activity|
            memo += person_activity.duracion.to_i
        end
        "#{horas} horas"
    end
end
