class InformeRendererService::ActivitiesGroupedRenderer
    def initialize(activitites)
        @activitites = activitites
    end

    def grouped_activities
        return @grouped_activities if @grouped_activities
        @grouped_activities = []
        activites_by_year.each do |key, activities|
            activities.each do |coursable, person_activities|
                @grouped_activities << ::InformeRendererService::SameActivitiesRenderer.new(
                    person_activities
                ).summarised_activities
            end
        end
        @grouped_activities
    end

    private

    ##
    # {
    #     "2023" => {
    #         Activity1 => [
    #             PersonActivity
    #         ],
    #         LegacyActivity1 => [
    #             LegacyPersonActivity
    #         ]
    #     }
    # }
    def activites_by_year
        @activitites.inject({}) do |memo, activity_renderer|
            memo[activity_renderer.year] ||= {}
            memo[activity_renderer.year][activity_renderer.activity] ||= []
            memo[activity_renderer.year][activity_renderer.activity] << activity_renderer
            memo
        end
    end
end
