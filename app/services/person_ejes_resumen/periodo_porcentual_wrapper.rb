class PersonEjesResumen::PeriodoPorcentualWrapper < PersonEjesResumen::PeriodoGenericWrapper
    def initialize(start_date:, end_date:, period_percentage:)
        @start_date = parse_date_str(start_date)
        @end_date = parse_date_str(end_date)
        @date_range = @start_date..@end_date
        @period_percentage = period_percentage
        @activities = []
    end

    private

    ##
    # "02/06/2022" => 02/06/2022
    def parse_date_str(date)
        Date.strptime(date, "%d/%m/%Y")
    end
end
