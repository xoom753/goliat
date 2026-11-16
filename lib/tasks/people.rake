namespace :people do
  desc "Update pavilion assignments for existing people"
  task update_pabellones: :environment do
    UpdatePeoplePabellonesTask.new.call
  end

  desc "Look for new people and create them"
  task create_new_people: :environment do
    CreateNewPeopleTask.new.call
  end

  task import_listado_pabellones: :environment do
    filename = "LISTADO-PABELLONES-16-11-2026.xlsx"
    xlsx = Roo::Spreadsheet.open(filename, extension: :xlsx)
    ImportListadoPabellonesTask.new(xlsx).import!
  end
end
