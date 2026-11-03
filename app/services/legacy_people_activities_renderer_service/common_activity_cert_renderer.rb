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

    attr_reader :year, :activity, :month, :kind, :duracion

    delegate :fix_ortography,
             to: :ortography_fixer

    def cert_string
        t_identifier =  if empty_prefix?
            "empty_prefix"
        elsif actividad_actividades?
            "actividades"
        elsif actividad_talleres?
            "taller"
        elsif actividad_cursos?
            "curso"
        elsif actividad_programas?
            "programa"
        else
            default_cert_string
        end
        look_in_dictionary(t_identifier)
    end

    protected

    def look_in_dictionary(t_identifier)
        I18n.t(
            "#{certs_prefix}.#{t_identifier}",
            actividad_str: actividad_str,
            meses_y_anio: get_months_and_year,
            duracion: duracion
        )
    end

    def default_cert_string
        if @kind == :laboral
            "actividades"
        else
            "curso"
        end
    end

    def certs_prefix
        "certs"
    end

    def get_months_and_year
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
            /panader/i,
            /cabello/i,
            /origami/i,
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
            /taller/i,
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
