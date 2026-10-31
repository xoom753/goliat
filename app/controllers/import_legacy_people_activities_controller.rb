class ImportLegacyPeopleActivitiesController < ApplicationController
    def new
    end

    def create
        parameters = params.expect(legacy_person_activities: [
            :legacy_activity_id,
            :legacy_activity_group_id,
            :duracion,
            :end_date,
            :people
        ])
        activities = []
        parameters[:people].split("\n").each_with_index do |person, index|
            activities << LegacyPersonActivity.new(
                row_number: index + 1,
                duracion: parameters[:duracion],
                end_date: parameters[:end_date],
                nombres_str: person.strip.titleize,
                legacy_activity_id: parameters[:legacy_activity_id],
                legacy_activity_group_id: parameters[:legacy_activity_group_id],
            )
        end
        LegacyPersonActivity.transaction do
            activities.each &:save!
        end
        redirect_to action: :new, notice: "#{activities.count} imported"
    end
end
