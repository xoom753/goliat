class ImportPeopleActivitiesController < ApplicationController
    def create
        activity = Activity.find(params[:activity_id])
        people_activities = params[:people_activities].split("\n")
        people_activities.each do |person_activity|
            nombres, dni, cargo = person_activity.split("\t")
            person = Person.find_by(dni: dni)

            if person.present?
                activity_record = PersonActivity.new(
                    person: person,
                    activity: activity,
                    mes: params[:date][:month],
                    anio: params[:date][:year]
                )
                # only set cargo if not default
                if cargo =~ /instructor/i
                    activity_record.cargo = :instructor
                end
                if cargo =~ /apoyo/i
                    activity_record.cargo = :apoyo
                end
                if cargo =~ /independiente/i
                    activity_record.cargo = :independiente
                end
                if cargo =~ /responsable/i
                    activity_record.cargo = :responsable
                end
                if cargo =~ /cp/i
                    activity_record.cargo = :cuentapropia
                end
                activity_record.save!
            else
                ImportError.create!(
                    details: {
                        nombres: nombres,
                        dni: dni,
                        cargo: cargo,
                        mes: params[:date][:month],
                        anio: params[:date][:year],
                        activity: activity.nombre
                    }.to_json
                )
            end
        end
        redirect_to action: :new, notice: "#{people_activities.count} imported!"
    end
end