class LegacyPeopleActivitiesRendererService::LegacyPersonActivityCertRenderer
    MESES = [
        "enero",
        "febrero",
        "marzo",
        "abril",
        "mayo",
        "junio",
        "julio",
        "agosto",
        "septiembre",
        "octubre",
        "noviembre",
        "diciembre"
    ].freeze

    delegate :fix_ortography,
             to: :@ortography_fixer

    def initialize(legacy_person_activity:, kind:)
        @kind = kind
        @legacy_person_activity = legacy_person_activity
        @ortography_fixer = ::LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer.new
    end

    def cert_string
        duracion = @legacy_person_activity.duracion.downcase
        t_identifier =  if empty_prefix?
            "certs.empty_prefix"
        elsif actividad_actividades?
            "certs.actividades"
        elsif actividad_talleres?
            "certs.taller"
        elsif actividad_cursos?
            "certs.curso"
        elsif actividad_programas?
            "certs.programa"
        else
            default_cert_string
        end
        I18n.t(
            t_identifier,
            actividad_str: actividad_str,
            mes_y_anio: get_month_and_year,
            duracion: duracion
        )
    end

    private

    def default_cert_string
        if @kind == :laboral
            "certs.actividades"
        else
            "certs.curso"
        end
    end

    def get_month_and_year
        date = @legacy_person_activity.end_date
        month = date.strftime("%m").to_i - 1 # 0 based
        "#{MESES.fetch(month)} de #{date.strftime("%Y")}"
    end

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

    def actividad_talleres?
        [
            /manualidades/i,
            /artesan/i,
            /panificaci/i,
            /tejido/i
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_cursos?
        [
            /panader/i
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_programas?
        [
            /teatral/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def empty_prefix?
        [
            /programa/i,
            /concurso/i,
            /agasajo/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_actividades?
        [
            /adecentamiento/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end
end
