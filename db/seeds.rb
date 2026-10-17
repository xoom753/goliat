# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding groups & activities"

{
    "Eje Cultural" => [
        "Canto",
        "Guitarra",
        "Lenguaje de señas",
        "Pintura"
    ],
    "Eje Deportivo" => [
        "Acondicionamiento Físico",
        "Halterofilia"
    ],
    "Eje Laboral" => [
        "Artesanías en hilo",
        "Carpintería",
        "Cultivo de huertos",
        "Mantenimiento y limpieza",
        "Origami",
        "Sastrería"
    ]
}.each do |group_name, activities|
    puts "= " + group_name
    group = ActivityGroup.where(
        nombre: group_name
    ).first_or_create!

    activities.each do |act_name|
        puts "    " + act_name
        activity = Activity.where(
            nombre: act_name
        ).first_or_initialize
        activity.activity_group = group
        activity.save!
    end
end

