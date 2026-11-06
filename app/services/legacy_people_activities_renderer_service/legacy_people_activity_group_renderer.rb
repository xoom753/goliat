class LegacyPeopleActivitiesRendererService::LegacyPeopleActivityGroupRenderer
    def initialize(person_ejes_resumen:, kind:)
        @kind = kind
        @person_ejes_resumen = person_ejes_resumen
    end

    def legacy_acts_details
        @legacy_acts_details ||=
            people_activities_by_date.inject([]) do |memo, (date, acts)|
                memo += acts
                memo
            end
    end

    ##
    # { date => ["act1", "act2"] }
    def people_activities_by_date
        @people_activities_by_date ||=
            people_activities.inject({}) do |memo, legacy_person_activity|
                act_date = legacy_person_activity.end_date
                memo[act_date] ||= []
                memo[act_date] << get_cert(legacy_person_activity)
                memo
            end
    end

    private

    def people_activities
        return [] if @person_ejes_resumen.legacy_people_ids.blank?
        activity_group = ActivityGroup.find_by!(
            nombre: "Eje #{@kind.to_s.capitalize}"
        )
        legacy_activity_groups = LegacyActivityGroup.where(
            activity_group: activity_group
        )
        legacy_person_activities = LegacyPersonActivity.where(
            legacy_activity_group: legacy_activity_groups,
            legacy_person: @person_ejes_resumen.legacy_people
        ).includes(
            :legacy_activity,
            :legacy_activity_group,
            :legacy_activity_detail
        ).oldest_first
    end

    def get_cert(legacy_person_activity)
        ::LegacyPeopleActivitiesRendererService::LegacyPersonActivityCertRenderer.new(
            legacy_person_activity: legacy_person_activity,
            kind: @kind
        )
    end
end
