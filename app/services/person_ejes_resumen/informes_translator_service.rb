class PersonEjesResumen::InformesTranslatorService
    def initialize(kind:)
        @kind = kind
        @kind_str = I18n.t("common.#{@kind}")
    end

    def t(identifier_key, kind_f: false, downcase: false)
        kind_str = @kind_str
        kind_str = @kind_str.downcase if downcase
        I18n.t(
            identifier_key,
            kind_str: kind_str
        )
    end

    private
end
