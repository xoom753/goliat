class LegacyPeopleActivitiesRendererService::PresentPeopleActivityGroupRenderer
    def initialize(person_ejes_resumen:, kind:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def present_acts_details
        @acts_details ||=
            people_activities_by_date.inject([]) do |memo, (date, acts)|
                memo += acts
                memo
            end
    end

    def people_activities_by_date
        @people_activities_by_date ||=
            people_activities.inject({}) do |memo, person_activity|
                act_date = person_activity.end_date
                memo[act_date] ||= []
                memo[act_date] << get_cert(person_activity)
                memo
            end
    end

    private

    def people_activities
        return [] if @person_ejes_resumen.people_ids.blank?
        activity_group = ActivityGroup.find_by!(
            nombre: "Eje #{@kind.to_s.capitalize}"
        )
        activities = activity_group.activities
        person_activities = PersonActivity.where(
            coursable: activities,
            person: @person_ejes_resumen.people
        ).includes(
            :coursable
        ).oldest_first
    end

    def get_cert(person_activity)
        ::LegacyPeopleActivitiesRendererService::PresentPersonActivityCertRenderer.new(
            person_activity: person_activity,
            kind: @kind
        )
    end
end
