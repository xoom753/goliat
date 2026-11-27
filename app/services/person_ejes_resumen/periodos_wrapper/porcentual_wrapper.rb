# Represents one percentage-based report period with parsed inclusive dates.
class PersonEjesResumen::PeriodosWrapper::PorcentualWrapper < PersonEjesResumen::PeriodosWrapper::GenericWrapper
    # @param kind [Symbol] treatment axis
    # @param start_date [String] start date in day/month/year format
    # @param end_date [String] end date in day/month/year format
    # @param period_percentage [String] period threshold label
    def initialize(kind:, start_date:, end_date:, period_percentage:)
        @kind = kind
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
