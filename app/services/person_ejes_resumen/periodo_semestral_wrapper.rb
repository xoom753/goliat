class PersonEjesResumen::PeriodoSemestralWrapper < PersonEjesResumen::PeriodoGenericWrapper
    def initialize(
            start_date:,
            end_date:,
            percentage:,
            semestre_str:,
            period_percentage:
        )
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
