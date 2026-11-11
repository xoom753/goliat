# require "update_people_pabellones_service"
# require "create_new_people_service"

namespace :people do
  desc "Update pavilion assignments for existing people"
  task update_pabellones: :environment do
    UpdatePeoplePabellonesService.new.call
  end

  desc "Look for new people and create them"
  task create_new_people: :environment do
    CreateNewPeopleService.new.call
  end
end
