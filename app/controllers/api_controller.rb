class ApiController < ApplicationController
    def people
        query = "'#{params[:q]}%'"
        results = Person.where(
            "nombres LIKE #{query}"
        ).limit(10)
        json_results = results.map do |result|
            {
                text: "#{result.nombres} - #{result.dni}",
                value: result.id
            }
        end
        render json: json_results
    end
end
