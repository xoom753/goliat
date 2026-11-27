# Calculates a capped grade from the duration of summarized period activities.
class PersonEjesResumen::PeriodQualifierService
    REQUIRED_HOURS = 30.0
    MAX_GRADE = 2.0

    # @param period [#group_similar_activities] period providing duration summaries
    def initialize(period)
        @period = period
    end

    # Calculates a grade from zero to the configured maximum and formats decimals with a comma.
    # @return [String] localized numeric grade
    def get_grade
        grade = (activities_h.to_f * MAX_GRADE) / REQUIRED_HOURS
        if grade > MAX_GRADE
            grade = MAX_GRADE
        else
            grade = grade.round(2)
        end
        grade = grade == grade.to_i ? grade.to_i.to_s : grade.to_s
        grade.sub(".", ",")
    end

    private

    def activities_h
        summarised_activities_array.inject(0) do |memo, activities_renderer|
            memo + activities_renderer.duracion_i
        end
    end

    def summarised_activities_array
        @period.group_similar_activities.values
    end
end
