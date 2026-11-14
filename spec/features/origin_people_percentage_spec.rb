require "rails_helper"

RSpec.describe "Origin people percentage listing", type: :feature do
  it "lists penalties with a sixty-percent milestone in date order" do
    people = %w[Casey Morgan Taylor].map do |name|
      OriginPerson.create!(
        fecha_registro: Date.new(2024, 1, 15),
        father_lastname: name,
        mother_lastname: "Example",
        first_name: "Person",
        dni: "#{name}123",
        situacion_actual: :presente
      )
    end
    later_process = people.first.origin_person_legal_processes.create!(
      proceso_num: "CASE-LATER",
      estado: :con_sentencia,
      anios_sentencia: 2
    )
    earlier_process = people.second.origin_person_legal_processes.create!(
      proceso_num: "CASE-EARLIER",
      estado: :con_sentencia,
      anios_sentencia: 3
    )
    OriginPersonLegalPenalty.create!(
      origin_person: people.first,
      origin_person_legal_process: later_process,
      sesenta_porciento_at_str: Date.new(2028, 1, 1)
    )
    OriginPersonLegalPenalty.create!(
      origin_person: people.second,
      origin_person_legal_process: earlier_process,
      sesenta_porciento_at_str: Date.new(2026, 1, 1)
    )
    no_milestone_process = people.last.origin_person_legal_processes.create!(
        proceso_num: "CASE-NO-MILESTONE",
        estado: :con_sentencia
      )
    OriginPersonLegalPenalty.create!(
      origin_person: people.last,
      origin_person_legal_process: no_milestone_process
    )

    visit by_percentage_origin_people_path(sort_by: "sesenta")

    expect(page).to have_content("Información jurídica")
    expect(page.body.index("CASE-EARLIER")).to be < page.body.index("CASE-LATER")
    expect(page).not_to have_content("CASE-NO-MILESTONE")
  end
end
