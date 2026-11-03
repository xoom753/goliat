class LegacyPeopleActivitiesRendererService::GroupedActivitiesCertRenderer < LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
    def initialize(person_activities:)
        @person_activities = person_activities
        @kind = @person_activities.first.kind
        @year = @person_activities.first.year
        @duracion = get_duracion
    end

    private

    def actividad_str
        @person_activities.first.send(:actividad_str)
    end

    def certs_prefix
        "grouped_certs"
    end

    def get_duracion
        horas = @person_activities.inject(0) do |memo, person_activity|
            memo += person_activity.duracion.to_i
        end
        "#{horas} horas"
    end

    def get_months_and_year
        last_activity = @person_activities.last
        first_part_activities = @person_activities[0...-1]
        first_part_str = first_part_activities.map do |activity|
            MESES.fetch(activity.month - 1)
        end.join(", ")
        [
            first_part_str,
            MESES.fetch(last_activity.month - 1)
        ].join(" y ") + " de #{@year}"
    end
end
