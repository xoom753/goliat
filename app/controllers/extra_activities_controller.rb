class ExtraActivitiesController < ApplicationController
    def index
        @extra_activities = ExtraActivity.all
    end

    def new
        next_id = ExtraActivity.count + 1
        extra_activity = ExtraActivity.create!(
            nombre: "Nueva Actividad extra #{next_id}"
        )
        redirect_to action: :edit, id: extra_activity.id
    end

    def edit
        @extra_activity = ExtraActivity.find params[:id]
        @person_activities = @extra_activity.person_activities
    end

    # adding a participant
    def update
        @person = Person.find(params.require(:person_id))
        @extra_activity = ExtraActivity.find(params[:id])
        if @person.present?
            PersonActivity.create!(
                person: @person,
                coursable: @extra_activity,
                mes: Date.today.month,
                anio: Date.today.year
            )
            dni = nil # clean input
        # else
        #     redirect_to action: :edit,
        #                 dni: params[:dni],
        #                 month: params[:month],
        #                 year: params[:year]
        end
        redirect_to action: :edit,
                        dni: dni,
                        month: params[:month],
                        year: params[:year]
    end

    def update_name
        @extra_activity = ExtraActivity.find params[:id]
        @extra_activity.update!(nombre: params.require(:nombre))
        redirect_to action: :edit
    end

    # removing a participant
    def destroy
        person_activity = PersonActivity.find(
            params.require(:person_activity_id)
        )
        person_activity.destroy
        redirect_to action: :edit
    end

    def export
        @extra_activity = ExtraActivity.find params[:id]
        activities = @extra_activity.person_activities

        headers = [
            "Nombres",
            "Cédula",
            "Pabellón",
            @extra_activity.nombre,
            @extra_activity.created_at.to_date,
            Time.now
        ]
        csv_data = CSV.generate(headers: true) do |csv|
            csv << headers
            activities.each do |activity|
                csv << [
                    activity.person.nombres,
                    activity.person.dni,
                    activity.person.pabellon,
                ]
            end
        end
        csv_name = "#{@extra_activity.nombre}-#{Date.today.to_s}"
        send_data csv_data,
                  filename: "#{csv_name}.csv",
                  disposition: :attachment
    end
end
