class LegacyPeopleActivitiesRendererService::PresentPersonActivityCertRenderer < LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
    QTY_H_DEFAULT = "30 horas".freeze

    def initialize(person_activity:, kind:)
        @kind = kind
        @person_activity = person_activity
        @duracion = @person_activity.qty_h || QTY_H_DEFAULT
        @activity_end_date = @person_activity.end_date
    end

    private

    def actividad_str
        @person_activity.coursable.nombre
    end
end
