# Translates report strings while applying treatment-axis-specific wording.
class PersonEjesResumen::ActivityToHumanRendererService::InformesTranslator
    # @param kind [Symbol] treatment axis whose localized report strings are used
    def initialize(kind:)
        @kind = kind
        @kind_str = I18n.t("common.#{@kind}")
        if apply_kind_f?
            @kind_str_f = I18n.t("common.#{@kind}_f")
        end
    end

    # Translates a key with the selected treatment-axis wording and case.
    # @param identifier_key [String] translation key
    # @param kind_f [Boolean] whether to use feminine wording when available
    # @param downcase [Boolean] whether to lowercase the treatment-axis label
    # @return [String] formatted translation
    def stringify(identifier_key, kind_f: false, downcase: false)
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
