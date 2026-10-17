class CoursesController < ApplicationController
    # def show
    #     @activity = Activity.find params[:id]
    # end

    def edit
        @month = params.require(:month)
        @year = params.require(:year)
        @activity = Activity.find params[:id]
        @person_activities = @activity.person_activities.where(
            mes: @month,
            anio: @year
        )
    end

    # adding a participant
    def update
        @person = Person.find(params.require(:person_id))
        @activity = Activity.find(params[:id])
        if @person.present?
            PersonActivity.create!(
                person: @person,
                coursable: @activity,
                mes: params[:month],
                anio: params[:year]
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

    # removing a participant
    def destroy
        person_activity = PersonActivity.find(
            params.require(:person_activity_id)
        )
        person_activity.destroy
        redirect_to action: :edit,
                    month: params[:month],
                    year: params[:year]
    end
end
