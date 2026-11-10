class PersonEjesResumen::ActivityToHumanRendererService::ActivityKindIdentifier
    attr_reader :identifier_str

    FEMININE_ACTIVITIES = [
        :actividades,
        :actividades_apoyo
    ].freeze

    def initialize(kind:, activity_str:)
        @kind = kind
        @activity_str = activity_str
        set_activity_kind_identifier!
    end

    def genre
        if @identifier_str.in?(FEMININE_ACTIVITIES)
            "feminine"
        else
            "masculine"
        end
    end

    private

    def set_activity_kind_identifier!
        @identifier_str = :actividades if actividad_actividades?
        @identifier_str = :actividades_apoyo if actividad_actividades_apoyo?
        @identifier_str = :taller if actividad_talleres?
        @identifier_str = :curso if actividad_cursos?
        @identifier_str = :programa if actividad_programas?
        @identifier_str = :campeonato if actividad_campeonato?
        @identifier_str = :empty_prefix if empty_prefix?
        @identifier_str = default_cert_kind_string if @identifier_str.blank?
        @identifier_str
    end

    def actividad_talleres?
        [
            /manualidades/i,
            /artesan/i,
            /panificaci/i,
            /tejido/i,
            /tapizado/i
        ].any? do |regex|
            @activity_str =~ regex
        end
    end

    def actividad_cursos?
        [
            /panader/i,
            /cabello/i,
            /origami/i,
            /electricidad b/i,
        ].any? do |regex|
            @activity_str =~ regex
        end
    end

    def actividad_programas?
        [
            /teatral/i,
        ].any? do |regex|
            @activity_str =~ regex
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
            @activity_str =~ regex
        end
    end

    def actividad_actividades?
        [
            /adecentamiento/i,
            /coros/i,
        ].any? do |regex|
            @activity_str =~ regex
        end
    end

    def actividad_actividades_apoyo?
        [
            /área laboral/i,
        ].any? do |regex|
            @activity_str =~ regex
        end
    end

    def actividad_campeonato?
        [
            /copa/i,
        ].any? do |regex|
            @activity_str =~ regex
        end
    end

    def default_cert_kind_string
        if @kind == :laboral
            :actividades
        else
            :curso
        end
    end
end
