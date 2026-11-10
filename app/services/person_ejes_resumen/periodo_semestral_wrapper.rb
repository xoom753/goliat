class PersonEjesResumen::PeriodoSemestralWrapper < PersonEjesResumen::PeriodoGenericWrapper
    attr_reader :semestre_str

    def initialize(
            kind:,
            start_date:,
            end_date:,
            percentage:,
            semestre_str:,
            period_percentage:
        )
        @kind = kind
        @start_date = parse_date_str(start_date)
        @end_date = parse_date_str(end_date)
        @percentage = percentage
        @semestre_str = semestre_str
        @period_percentage = period_percentage
        @date_range = @start_date..@end_date
        @activities = []
    end

    private

    ##
    # "02/06/22" => 02/06/2022
    def parse_date_str(date)
        Date.strptime(date, "%d/%m/%y")
    end
end
