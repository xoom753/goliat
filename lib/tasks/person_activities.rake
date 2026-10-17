namespace :person_activities do
    task default_coursable: :environment do
        PersonActivity.find_each do |person_activity|
            person_activity.update!(coursable_type: "Activity")
        end
    end
end
