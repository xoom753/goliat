class PersonEjesResumen::LegacyActivitiesFetcherService
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def activities
        activity_group = ActivityGroup.find_by!(
            nombre: "Eje #{@kind.to_s.titleize}"
        )
        legacy_activity_groups = LegacyActivityGroup.where(
            activity_group: activity_group
        )
        LegacyPersonActivity.where(
            legacy_person: @person_ejes_resumen.legacy_people,
            legacy_activity_group: legacy_activity_groups
        )
    end
end
