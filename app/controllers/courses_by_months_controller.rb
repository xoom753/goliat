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

        activities = activity.person_activities.sorted.where(
            mes: month,
            anio: year
        )

        @headers = [
            "Nombres",
            "Cédula",
            "Cargo",
            "Pabellón",
            "Celda",
            "Exportado: #{Time.zone.now}"
        ]
        @rows = activities.map do |activity|
            [
                activity.person.nombres,
                activity.person.dni,
                activity.cargo.upcase,
                activity.person.pabellon,
                activity.person.celda
            ]
        end

        filename_base = "#{activity.nombre}-#{Date::MONTHNAMES[month.to_i]}-#{Date.today}"

        respond_to do |format|
            format.xls do
                response.headers["Content-Disposition"] = "attachment; filename=\"#{filename_base}.xls\""
            end

            format.csv do
                csv_data = CSV.generate(headers: true) do |csv|
                    csv << @headers
                    @rows.each do |row|
                        csv << row
                    end
                end

                send_data csv_data,
                        filename: "#{filename_base}.csv",
                        disposition: :attachment
            end
        end
    end
end
