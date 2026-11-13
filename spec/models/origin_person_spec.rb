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

  it "keeps the enum default when situacion_actual_str is nil" do
    origin_person.situacion_actual_str = nil

    origin_person.save!

    expect(origin_person.situacion_actual).to eq("presente")
  end

  it "preserves the enum default when the supplied status is blank" do
    origin_person.situacion_actual_str = ""

    origin_person.save!

    expect(origin_person.situacion_actual).to eq("presente")
  end

  it "has the supported situacion_actual values" do
    expect(described_class.situacion_actuals).to include(
      "presente" => 0,
      "presente_beneficio_revocado" => 1
    )
  end

  it "provides its demographic and legal-process associations" do
    expect(described_class.reflect_on_association(:origin_person_demographic).macro).to eq(:has_one)
    expect(described_class.reflect_on_association(:origin_person_legal_processes).macro).to eq(:has_many)
    expect(described_class.reflect_on_association(:origin_person_legal_penalties).macro).to eq(:has_many)
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
