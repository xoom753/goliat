class LegacyPeopleActivitiesRendererService::CommonActivityCertRenderer
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
             to: :ortography_fixer

    def cert_string
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
            duracion: @duracion
        )
    end

    protected

    def default_cert_string
        if @kind == :laboral
            "certs.actividades"
        else
            "certs.curso"
        end
    end

    def get_month_and_year
        month = @activity_end_date.strftime("%m").to_i - 1 # 0 based
        "#{MESES.fetch(month)} de #{@activity_end_date.strftime("%Y")}"
    end

    def ortography_fixer
        @ortography_fixer ||=
            ::LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer.new
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
