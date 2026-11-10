class PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer
    KNOWN_WORDS = {
        "O" => "o",
        "Y" => "y",
        "De" => "de",
        "En" => "en",
        "Area" => "Área",
        "Pabellon" => "Pabellón",
        "Formacion" => "Formación",
        "Panaderia" => "Panadería",
        "Lavanderia" => "Lavandería",
        "Pasteleria" => "Pastelería",
        "Artesanias" => "Artesanías",
        "Actividadesdeportivas" => "Actividades deportivas",
    }.freeze

    def initialize(actividad_str:)
        @actividad_str = actividad_str
    end

    def activity_str
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
