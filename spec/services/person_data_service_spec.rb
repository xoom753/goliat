require "rails_helper"

RSpec.describe PersonDataService do
  let(:legacy_person) { LegacyPerson.create!(nombres: "CASEY EXAMPLE", dni: legacy_dni) }
  let(:legacy_dni) { nil }

  it "uses the legacy person's DNI when present" do
    legacy_person.update!(dni: "legacy-dni")

    service = described_class.new(legacy_person)

    expect(service.dni).to eq("legacy-dni")
  end

  it "falls back to the current person DNI and pavilion by uppercase name" do
    Person.create!(nombres: "CASEY EXAMPLE", dni: "current-dni", pabellon: "B-2")

    service = described_class.new(legacy_person)

    expect(service.dni).to eq("current-dni")
    expect(service.ubicacion).to eq("B-2")
  end

  it "returns the earliest detention date for the matching origin person" do
    origin_person = OriginPerson.create!(
      fecha_registro: Date.new(2025, 1, 1),
      father_lastname: "CASEY",
      first_name: "EXAMPLE"
    )
    origin_person.origin_person_legal_processes.create!(fecha_detencion: Date.new(2021, 5, 1))
    origin_person.origin_person_legal_processes.create!(fecha_detencion: Date.new(2019, 3, 1))

    service = described_class.new(legacy_person)

    expect(service.fecha_detencion).to eq(Date.new(2019, 3, 1))
  end
end
