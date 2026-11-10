class PersonEjesResumen::ActivityToHumanRendererService::OrtographyFixer
    ##
    # todo extract these constants to yml files
    ##

    KNOWN_WORDS = {
        "A" => "a",
        "O" => "o",
        "Y" => "y",
        "De" => "de",
        "En" => "en",
        "Cpl" => "CPL",
        "Del" => "del",
        "Dia" => "día",
        "Area" => "Área",
        "Jose" => "José",
        "Fenix" => "Fénix",
        "Fomix" => "Fómix",
        "Hurto" => "Huerto",
        "Basica" => "Básica",
        "Organico" => "Orgánico",
        "Ceramica" => "Cerámica",
        "Pabellon" => "Pabellón",
        "Aerobicos" => "Aeróbicos",
        "Formacion" => "Formación",
        "Panaderia" => "Panadería",
        "Peluqeria" => "Peluquería",
        "Peluqueria" => "Peluquería",
        "Lavanderia" => "Lavandería",
        "Pasteleria" => "Pastelería",
        "Artesanias" => "Artesanías",
        "Carpinteria" => "Carpintería",
        "ZAPATERIA" => "Zapatería",
        "Actividadesdeportivas" => "Actividades deportivas",
        "Actividadesderecreación" => "Actividades de recreación",
    }.freeze

    KNOWN_ACTIVITIES = {
        "Area Laboral Del Cpl L 1" => "Área Laboral Del CPL-L 1",
        "Artesplástica Sy Visuales" => "Artes plásticas y Visuales",
        "Adultos Mayores \"Caminando, Con Grandes Amigos\"" => "Adultos Mayores \"Caminando Con Grandes Amigos\"",
        "Curso De Manualidades Liberados Por Amor" => "Curso De Manualidades \"Liberados Por Amor\"",
        "ELECTRICISTA" => "Electricista",
        "Mantenimiento Y Limpieza De Pabellon A" => "Mantenimiento y Limpieza de Pabellón A",
        "Mantenimiento Y Limpieza De Pabellón A" => "Mantenimiento y Limpieza de Pabellón A",
        "Mantenimiento Y Limpieza Del Pabellón A" => "Mantenimiento y Limpieza del Pabellón A",
        "Manualidades Dia De Madre" => "Manualidades día de la Madre",
        "Prácticas O Aprendizaje De Instrumentos Musicales" => "Aprendizaje De Instrumentos Musicales",
        "Redes De Ecuavoley, Atarrayas Hamacas Y Esferos Bordados" => "Redes de ecuavóley, atarrayas, hamacas y esferos bordados"
    }.freeze

    def initialize(actividad_str:)
        @actividad_str = actividad_str
    end

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
