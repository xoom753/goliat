class PersonEjesResumen::PresentActivitiesFetcherService
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def activities
        activity_group = ActivityGroup.find_by!(
            nombre: "Eje #{@kind.to_s.titleize}"
        )
        activities = Activity.where(
            activity_group: activity_group
        )
        PersonActivity.where(
            person: @person_ejes_resumen.people,
            coursable: activities
        )
    end
end
