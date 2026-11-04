class LegacyPeopleActivitiesRendererService::PresentPersonActivityCertRenderer < LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
    QTY_H_DEFAULT = "30 horas".freeze

    def initialize(person_activity:, kind:)
        @kind = kind
        @person_activity = person_activity
        @duracion = @person_activity.qty_h || QTY_H_DEFAULT
        @activity_end_date = @person_activity.end_date
        @year = @person_activity.anio
        @activity = @person_activity.coursable
        @month = @person_activity.mes
    end

    def actividad_str
        @person_activity.coursable.nombre
    end
end
