class Person::PabellonParserService
    attr_reader :pabellon, :celda

    def initialize(person)
        @person = person
        set_pabellon!
    end

    private

    def set_pabellon!
        pabellon_string = @person.pabellon
        @celda = pabellon_string
        if pabellon_string =~ /CELDA_CHOF/
            @pabellon = "Choferes"
            @celda = pabellon_string.sub("CELDA_CHOF_", "").titleize
        elsif pabellon_string =~ /CELDA_A/
            @pabellon = "A"
            @celda = pabellon_string.sub("CELDA_A_", "").to_i
        elsif pabellon_string =~ /CELDA_B/
            @pabellon = "B"
            @celda = pabellon_string.sub("CELDA_B_", "").to_i
        elsif pabellon_string =~ /CELDA_C_/
            @pabellon = "C"
            @celda = pabellon_string.sub("CELDA_C_", "").to_i
        elsif pabellon_string =~ /CELDA_D/
            @pabellon = "D"
            @celda = pabellon_string.sub("CELDA_D_", "").to_i
        elsif pabellon_string =~ /CELDA_E/
            @pabellon = "E"
            @celda = pabellon_string.sub("CELDA_E_", "").to_i
        elsif pabellon_string =~ /CELDA_F/
            @pabellon = "F"
            @celda = pabellon_string.sub("CELDA_F_", "").to_i
        elsif pabellon_string =~ /CELDA_H/
            @pabellon = "H"
            @celda = pabellon_string.sub("CELDA_H_", "").to_i
        elsif pabellon_string =~ /CELDA_SAN_JOSE/
            @pabellon = "San José"
            @celda = pabellon_string.sub("CELDA_SAN_JOSE_", "").titleize
        elsif pabellon_string =~ /CUARENTENA/
            @pabellon = "Cuarentena"
            @celda = pabellon_string.sub("CUARENTENA_", "")
        elsif pabellon_string =~ /CELDA_CUAR_/
            @pabellon = "Cuarentena"
            @celda = pabellon_string.sub("CELDA_CUAR_", "")
        elsif pabellon_string =~ /PABELLON_A/
            @pabellon = "A"
        end
    end
end
