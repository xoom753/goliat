# Fetches current activities associated with a report's selected people.
class PersonEjesResumen::ActivitiesFetcherService::PresentActivitiesFetcher
    # @param kind [Symbol] treatment axis to filter
    # @param person_ejes_resumen [PersonEjesResumen] report supplying current people
    def initialize(kind:, person_ejes_resumen:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    # Returns matching current activities for the report.
    # @return [Array<PersonActivity>]
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
