class LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer
    KNOWN_WORDS = {
        "Lavanderia" => "Lavandería",
        "Panaderia" => "Panadería",
        "Pasteleria" => "Pastelería",
        "Actividadesdeportivas" => "Actividades deportivas"
    }.freeze

    def fix_ortography(word)
        return KNOWN_WORDS[word] if KNOWN_WORDS[word]
        return word
    end
end
