class LegacyPeopleActivitiesRendererService::LegacyPersonActivityCertRenderer < LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
    def initialize(legacy_person_activity:, kind:)
        @kind = kind
        @legacy_person_activity = legacy_person_activity
        @duracion = @legacy_person_activity.duracion.downcase
        @activity_end_date = @legacy_person_activity.end_date
    end

    private

    def actividad_str
        # remove whitespaces
        @actividad_str ||=
            @legacy_person_activity.legacy_activity
                                   .nombre
                                   .split(" ")
                                   .map do |word|
            fix_ortography(word.strip)
        end.join(" ")
    end
end
