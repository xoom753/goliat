require "rails_helper"

RSpec.describe OriginPersonLegalProcess, type: :model do
  let(:origin_person) do
    OriginPerson.create!(
      fecha_registro: Date.new(2025, 1, 1),
      father_lastname: "Pérez",
      first_name: "Ana"
    )
  end

  it "has the supported estado values" do
    expect(described_class.estados).to include("en_proceso" => 0, "con_sentencia" => 1)
  end

  it "maps estado_str to the enum before saving" do
    process = described_class.new(origin_person: origin_person)
    process.estado_str = "Con Sentencia"

    process.save!

    expect(process.estado).to eq("con_sentencia")
  end

  it "preserves the default state when estado_str is blank" do
    process = described_class.create!(origin_person: origin_person, estado_str: "")

    expect(process.estado).to eq("en_proceso")
  end

  it "has one legal penalty" do
    expect(described_class.reflect_on_association(:origin_person_legal_penalty).macro).to eq(:has_one)
  end
end
