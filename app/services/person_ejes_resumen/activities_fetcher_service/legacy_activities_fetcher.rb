# Fetches historical activities associated with a report's legacy people.
class PersonEjesResumen::ActivitiesFetcherService::LegacyActivitiesFetcher
    # @param kind [Symbol] treatment axis to filter
    # @param person_ejes_resumen [PersonEjesResumen] report supplying legacy people
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    # Returns matching historical activities for the report.
    # @return [Array<LegacyPersonActivity>]
    def activities
        return [] if @person_ejes_resumen.legacy_people_ids.blank?
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
