require "rails_helper"

RSpec.describe PersonEjesResumen, type: :model do
  subject(:resumen) do
    described_class.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 1),
      delitos: "Robo\nHurto",
      sentencias: "Sentencia A\nSentencia B",
      semestres_porcentuales: "",
      periodos_detalle: ""
    )
  end

  it "splits delitos into lines" do
    expect(resumen.delitos_array).to eq(["Robo", "Hurto"])
  end

  it "splits sentencias into lines" do
    expect(resumen.sentencias_array).to eq(["Sentencia A", "Sentencia B"])
  end

  it "finds associated legacy people from their comma-separated ids" do
    first = LegacyPerson.create!(nombres: "First")
    second = LegacyPerson.create!(nombres: "Second")
    resumen.legacy_people_ids = "#{first.id},#{second.id}"

    expect(resumen.legacy_people).to eq([first, second])
  end

  it "finds associated people from their comma-separated ids" do
    first = Person.create!(nombres: "First")
    second = Person.create!(nombres: "Second")
    resumen.people_ids = "#{first.id},#{second.id}"

    expect(resumen.people).to eq([first, second])
  end

  it "updates last_generated_at" do
    resumen.save!

    expect { resumen.update_last_generated_at! }.to change(resumen, :last_generated_at)
  end

  it "memoizes parsed text arrays" do
    expect(resumen.delitos_array).to equal(resumen.delitos_array)
    expect(resumen.sentencias_array).to equal(resumen.sentencias_array)
  end
end
