class PersonEjesResumen::ActivityToHumanRendererService::InformesTranslator
    def initialize(kind:)
        @kind = kind
        @kind_str = I18n.t("common.#{@kind}")
        if apply_kind_f?
            @kind_str_f = I18n.t("common.#{@kind}_f")
        end
    end

    def t(identifier_key, kind_f: false, downcase: false)
        kind_str = get_kind_str(kind_f: kind_f)
        kind_str = kind_str.downcase if downcase
        I18n.t(
            identifier_key,
            kind_str: kind_str
        )
    end

    private

    def apply_kind_f?
        @kind == :deportivo || @kind == :educativo
    end

    def get_kind_str(kind_f:)
        if kind_f && apply_kind_f?
            @kind_str_f
        else
            @kind_str
        end
    end
end
