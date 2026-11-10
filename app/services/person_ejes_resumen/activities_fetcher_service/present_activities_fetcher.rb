class PersonEjesResumen::ActivitiesFetcherService::PresentActivitiesFetcher
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def activities
        return [] if @person_ejes_resumen.people_ids.blank?
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
