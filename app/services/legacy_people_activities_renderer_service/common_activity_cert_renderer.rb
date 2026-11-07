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
        look_in_dictionary
    end

    def get_months_and_year(upcase: false)
        month = @activity_end_date.strftime("%m").to_i - 1 # 0 based
        month_str = MESES.fetch(month)
        month_str = month_str.upcase if upcase
        "#{month_str} de #{@activity_end_date.strftime("%Y")}"
    end

    def activity_kind_str
        I18n.t(
            "#{certs_prefix}.activity_kind.#{activity_kind_identifier}"
        )
    end

    def duracion_str
        return duracion if duracion.include?("horas")
        "#{duracion} horas"
    end

    protected

    def look_in_dictionary
        I18n.t(
            "#{certs_prefix}.#{activity_kind_identifier}",
            actividad_str: actividad_str,
            meses_y_anio: get_months_and_year,
            duracion: duracion_str,
            actividad_kind: activity_kind_str
        )
    end

    def default_cert_kind_string
        if @kind == :laboral
            "actividades"
        else
            "curso"
        end
    end

    def certs_prefix
        "certs"
    end

    def ortography_fixer
        @ortography_fixer ||=
            ::LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer.new
    end

    def activity_kind_identifier
        identifier_str = "actividades" if actividad_actividades?
        identifier_str = "actividades_apoyo" if actividad_actividades_apoyo?
        identifier_str = "taller" if actividad_talleres?
        identifier_str = "curso" if actividad_cursos?
        identifier_str = "programa" if actividad_programas?
        identifier_str = "campeonato" if actividad_campeonato?
        identifier_str = "empty_prefix" if empty_prefix?
        identifier_str = default_cert_kind_string if identifier_str.blank?
        identifier_str
    end

    def actividad_talleres?
        [
            /manualidades/i,
            /artesan/i,
            /panificaci/i,
            /tejido/i,
            /tapizado/i
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_cursos?
        [
            /panader/i,
            /cabello/i,
            /origami/i,
            /electricidad b/i,
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
            /cine/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_actividades?
        [
            /adecentamiento/i,
            /coros/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_actividades_apoyo?
        [
            /área laboral/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end

    def actividad_campeonato?
        [
            /copa/i,
        ].any? do |regex|
            actividad_str =~ regex
        end
    end
end
