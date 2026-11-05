require "rails_helper"

RSpec.describe PersonEjesResumen, type: :model do
  subject(:resumen) do
    described_class.new(
      delitos: "Robo\nHurto",
      sentencias: "Sentencia A\nSentencia B"
    )
  end

  it "splits delitos into lines" do
    expect(resumen.delitos_array).to eq(["Robo", "Hurto"])
  end

  it "splits sentencias into lines" do
    expect(resumen.sentencias_array).to eq(["Sentencia A", "Sentencia B"])
  end

  it "memoizes parsed text arrays" do
    expect(resumen.delitos_array).to equal(resumen.delitos_array)
    expect(resumen.sentencias_array).to equal(resumen.sentencias_array)
  end
end
