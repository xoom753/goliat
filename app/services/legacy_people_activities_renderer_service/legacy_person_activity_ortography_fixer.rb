class LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer
    KNOWN_WORDS = {
        "Lavanderia" => "Lavandería",
        "Panaderia" => "Panadería",
        "Pasteleria" => "Pastelería",
        "Artesanias" => "Artesanías",
        "Actividadesdeportivas" => "Actividades deportivas",
        "Pabellon" => "Pabellón",
        "Formacion" => "Formación",
        "De" => "de",
        "O" => "o",
        "Y" => "y",
        "En" => "en"
    }.freeze

    def fix_ortography(word)
        return KNOWN_WORDS[word] if KNOWN_WORDS[word]
        return word
    end
end
