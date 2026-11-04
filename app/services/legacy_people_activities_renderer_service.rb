class LegacyPeopleActivitiesRendererService
    def initialize(person_ejes_resumen)
        @person_ejes_resumen = person_ejes_resumen
    end

    def activities_list_for(kind)
        # first concat them
        # later: sort by date
        legacy_acts = legacy_people_activity_group_renderer_for(kind).legacy_acts_details
        present_acts = present_people_activity_group_renderer_for(kind).present_acts_details
        legacy_acts + present_acts
    end

    def activities_by_date_for(kind)
        legacy_acts = legacy_people_activity_group_renderer_for(kind).people_activities_by_date
        present_acts = present_people_activity_group_renderer_for(kind).people_activities_by_date
        # do not cache these
        # return @merged_acts if @merged_acts
        @merged_acts = {}
        legacy_acts.each do |date, activities|
            @merged_acts[date] ||= []
            @merged_acts[date] += activities
        end
        present_acts.each do |date, activities|
            @merged_acts[date] ||= []
            @merged_acts[date] += activities
        end
        @merged_acts
    end

    private

    def legacy_people_activity_group_renderer_for(kind)
        @legacy_kinds ||= {}
        @legacy_kinds[kind] ||= LegacyPeopleActivityGroupRenderer.new(
            kind: kind,
            person_ejes_resumen: @person_ejes_resumen
        )
    end

    def present_people_activity_group_renderer_for(kind)
        @present_kinds ||= {}
        @present_kinds[kind] ||= PresentPeopleActivityGroupRenderer.new(
            kind: kind,
            person_ejes_resumen: @person_ejes_resumen
        )
    end
end
