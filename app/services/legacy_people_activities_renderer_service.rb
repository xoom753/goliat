class LegacyPeopleActivitiesRendererService
    def initialize(person_ejes_resumen)
        @person_ejes_resumen = person_ejes_resumen
    end

    def activities_list_for(kind)
        legacy_people_activity_group_renderer_for(kind).legacy_acts_details
    end

    def activities_by_date_for(kind)
        legacy_people_activity_group_renderer_for(kind).people_activities_by_date
    end

    private

    def legacy_people_activity_group_renderer_for(kind)
        @kinds ||= {}
        @kinds[kind] ||= LegacyPeopleActivityGroupRenderer.new(
            kind: kind,
            person_ejes_resumen: @person_ejes_resumen
        )
    end
end
