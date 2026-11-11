class ApiController < ApplicationController
    def people
        query = "'%#{params[:q]}%'"
        results = Person.where(
            "nombres LIKE #{query} OR dni LIKE #{query}"
        ).limit(20)
        json_results = results.map do |result|
            {
                text: "#{result.nombres} - #{result.dni}",
                value: result.id
            }
        end
        render json: json_results
    end

    def legacy_people
        query = "'%#{params[:q]}%'"
        results = LegacyPerson.where(
            "nombres LIKE #{query}"
        ).limit(20)
        json_results = results.map do |result|
            {
                text: "#{result.nombres} - (uuid #{result.id})",
                value: result.id
            }
        end
        render json: json_results
    end
end
