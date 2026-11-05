require "rails_helper"

RSpec.describe OriginPerson, type: :model do
  subject(:origin_person) do
    described_class.new(
      fecha_registro: Date.new(2025, 1, 1),
      father_lastname: "Pérez",
      mother_lastname: "López",
      first_name: "Ana",
      middle_name: "María"
    )
  end

  it "builds fullname from nonblank name parts before saving" do
    origin_person.save!

    expect(origin_person.fullname).to eq("Pérez López Ana María")
  end

  it "sets situacion_actual from the supplied string" do
    origin_person.situacion_actual_str = "PRESENTE_BENEFICIO Revocado"

    origin_person.save!

    expect(origin_person.situacion_actual).to eq("presente_beneficio_revocado")
  end

  it "omits blank name parts when building fullname" do
    origin_person.mother_lastname = nil
    origin_person.middle_name = ""

    origin_person.save!

    expect(origin_person.fullname).to eq("Pérez Ana")
  end

  ##
  # nope, this is ImportOriginPeopleTask
  # describe "strips whitespaces" do
  #   subject(:origin_person) do
  #     described_class.create(
  #       fecha_registro: Date.new(2025, 1, 1),
  #       father_lastname: " Pérez",
  #       mother_lastname: "López ",
  #       first_name: "Ana ",
  #       middle_name: " María"
  #     )
  #   end

  #   it {
  #     expect(origin_person.fullname).to eq("Pérez López Ana María")
  #   }
  # end
end
