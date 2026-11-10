class PersonEjesResumen::ActivityToHumanRendererService::ActivityMonthsAndYearsRenderer
    MESES = [
        "enero",
        "febrero",
        "marzo",
        "abril",
        "mayo",
        "junio",
        "julio",
        "agosto",
        "septiembre",
        "octubre",
        "noviembre",
        "diciembre"
    ].freeze

    def initialize(by_months:)
        @by_months = by_months
    end

    def meses_y_anios_str(upcase:)
        if @by_months.keys.length > 1
            several_months_str(upcase:)
        else
            singular_month_str(upcase:)
        end
    end

    private

    def singular_month_str(upcase:)
        mes = get_meses_y_anios.first
        mes_str = mes[:mes]
        mes_str = mes_str.upcase if upcase
        "#{mes_str} de #{mes[:anio]}"
    end

    def several_months_str(upcase:)
        meses_y_anios = get_meses_y_anios
        last_month = meses_y_anios.last
        first_part_months = meses_y_anios[0...-1]
        first_part_str = first_part_months.map do |mes_y_anio|
            mes_str = mes_y_anio[:mes]
            mes_str = mes_str.upcase if upcase
            if years.length > 1
                "#{mes_str} de #{mes_y_anio[:anio]}"
            else
                mes_str
            end
        end.join(", ")
        last_month_str = last_month[:mes]
        last_month_str = last_month_str.upcase if upcase
        last_part_str = if years.length > 1
            "#{last_month_str} de #{last_month[:anio]}"
        else
            last_month_str
        end
        activities_str = [
            first_part_str, last_part_str
        ].join(" y ")
        if years.length > 1
            activities_str
        else
            "#{activities_str} de #{years.first}"
        end
    end

    def get_meses_y_anios
        @by_months.keys.sort.map do |date|
            mes = date.strftime("%m").to_i - 1 # 0 based
            {
                mes: MESES.fetch(mes),
                anio: date.year
            }
        end
    end

    def years
        @years ||= @by_months.keys.map do |date|
            date.year
        end.uniq
    end
end
