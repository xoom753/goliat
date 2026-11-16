class ImportListadoPabellonesTask
    def initialize(xlsx)
        @sheet = xlsx.sheet(0)
        @pabellones_list = Rails.application.config_for(:pabellones_list)[:pabellones_list].stringify_keys
        @prefixes = Rails.application.config_for(:pabellones_list)[:prefixes].stringify_keys
        @specific_celdas = Rails.application.config_for(:pabellones_list)[:specific_celdas].stringify_keys
    end

    def import!
        skip_headers = 6
        current_row_n = 0
        current_pabellon = nil
        current_celda = nil
        @sheet.each do |row|
            val = row[0]
            if current_row_n < skip_headers
                # skip header
            elsif row_is_pabellon?(val)
                current_pabellon = get_pabellon(val)
                puts current_pabellon.titleize
            elsif row_is_celda?(val)
                current_celda = get_current_celda(val:, current_pabellon:)
                puts "    " + current_celda.titleize
            elsif val.present? && val != "Total general"
                persist!(val:, current_celda:, current_pabellon:)
            end
            current_row_n += 1
        end
    end

    private

    def persist!(val:, current_celda:, current_pabellon:)
        PersonPabellonUpdate.create!(
            nombres: val,
            celda: current_celda.titleize,
            pabellon: current_pabellon.titleize
        )
    end

    def row_is_pabellon?(val)
        val =~ /pabellon/i || @pabellones_list.has_key?(val)
    end

    def row_is_celda?(val)
        val =~ /celda_/i
    end

    def get_current_celda(val:, current_pabellon:)
        if @specific_celdas.has_key?(val)
            return @specific_celdas.fetch(val)
        end

        celda = val.sub("CELDA_", "").sub("#{current_pabellon}_", "")
        pab_prefix = @prefixes[current_pabellon]
        if pab_prefix
            celda = celda.sub(pab_prefix, "")
        end
        celda
    end

    def get_pabellon(val)
        if @pabellones_list.has_key?(val)
            @pabellones_list.fetch(val)
        else
            val.sub("PABELLON_", "")
        end
    end
end
