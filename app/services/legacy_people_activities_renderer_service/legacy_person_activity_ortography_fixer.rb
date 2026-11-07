class LegacyPeopleActivitiesRendererService::LegacyPersonActivityOrtographyFixer
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

    def fix_ortography(word)
        return KNOWN_WORDS[word] if KNOWN_WORDS[word]
        return word
    end
end
