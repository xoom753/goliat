class ApiController < ApplicationController
    def people
        results = Person.where(
            "nombres ILIKE :query OR dni LIKE :query",
            query: "%#{params[:q]}%"
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
        results = LegacyPerson.where(
            "nombres ILIKE :query",
            query: "%#{params[:q]}%"
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
