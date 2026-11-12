require "csv"

class CoursesByMonthsController < ApplicationController
    def show
        @month = params.dig(:date, :month).presence || Date.today.month
        @year = params.dig(:date, :year).presence || Date.today.year
        if params[:activity_group_id].present?
            @activity_groups = ActivityGroup.where(id: params[:activity_group_id])
        else
            @activity_groups = ActivityGroup.all
        end
        @pabellon = params[:pabellon]
    end

    def export
        activity = Activity.find(params.require(:activity_id))
        month = params.require(:month)
        year = params.require(:year)

        activities = activity.person_activities.where(
            mes: month,
            anio: year
        )

        csv_data = CSV.generate(headers: true) do |csv|
            csv << ["Nombres", "Cédula", "Cargo", "Pabellón"]
            activities.each do |activity|
                csv << [
                    activity.person.nombres,
                    activity.person.dni,
                    activity.cargo,
                    activity.person.pabellon,
                ]
            end
        end
        csv_name = "#{activity.nombre}-#{Date::MONTHNAMES[month.to_i]}-#{Date.today.to_s}"
        send_data csv_data,
                  filename: "#{csv_name}.csv",
                  disposition: :attachment
    end
end
