class PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer
    ortography_rules_yaml = YAML.load_file("config/ortography_rules.yml")

    KNOWN_WORDS = ortography_rules_yaml["known_words"].freeze
    KNOWN_ACTIVITIES = ortography_rules_yaml["known_activities"].freeze

    def initialize(actividad_str:)
        @actividad_str = actividad_str
    end

    ##
    # if replacing full activity, skip word by word
    def activity_str
        if KNOWN_ACTIVITIES.has_key?(@actividad_str)
            return KNOWN_ACTIVITIES.fetch(@actividad_str)
        end

        # remove whitespaces
        @actividad_str.split(" ")
                     .map do |word|
            fix_ortography(word.strip)
        end.join(" ")
    end

    private

    def fix_ortography(word)
        return KNOWN_WORDS[word] if KNOWN_WORDS[word]
        return word
    end
end
