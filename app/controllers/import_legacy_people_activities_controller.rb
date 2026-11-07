class ImportLegacyPeopleActivitiesController < ApplicationController
    def new
    end

    def create
        parameters = params.expect(legacy_person_activities: [
            :legacy_activity_id,
            :legacy_activity_group_id,
            :duracion,
            :end_date,
            :start_date,
            :people,
            :activity_dates,
            :activity_detail_str
        ])
        activities = []
        parameters[:people].split("\n").each_with_index do |person, index|
            nombres_str = person.strip.titleize.split(" ").join(" ")
            if nombres_str.blank?
                # skip empty rows
            else
                activities << LegacyPersonActivity.new(
                    row_number: index + 1,
                    duracion: parameters[:duracion],
                    end_date: parameters[:end_date],
                    start_date: parameters[:start_date],
                    activity_dates: parameters[:activity_dates],
                    nombres_str: nombres_str,
                    activity_detail_str: parameters[:activity_detail_str],
                    legacy_activity_id: parameters[:legacy_activity_id],
                    legacy_activity_group_id: parameters[:legacy_activity_group_id],
                )
            end
        end
        LegacyPersonActivity.transaction do
            activities.each &:save!
        end
        redirect_to new_import_legacy_people_activity_path, notice: "#{activities.count} imported"
    end
end
