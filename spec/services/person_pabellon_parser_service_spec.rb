require "rails_helper"

RSpec.describe Person::PabellonParserService do
  {
    "CELDA_CHOF_JEFE" => ["Choferes", "Jefe"],
    "CELDA_A_012" => ["A", 12],
    "CELDA_B_003" => ["B", 3],
    "CELDA_C_004" => ["C", 4],
    "CELDA_D_005" => ["D", 5],
    "CELDA_E_006" => ["E", 6],
    "CELDA_F_007" => ["F", 7],
    "CELDA_H_008" => ["H", 8],
    "CELDA_SAN_JOSE_CAPILLA" => ["San José", "Capilla"],
    "CUARENTENA_2" => ["Cuarentena", "2"],
    "CELDA_CUAR_3" => ["Cuarentena", "3"],
    "PABELLON_A" => ["A", "PABELLON_A"]
  }.each do |raw_pavilion, expected|
    it "parses #{raw_pavilion.inspect}" do
      parsed = described_class.new(Person.new(pabellon: raw_pavilion))

      expect(parsed.pabellon).to eq(expected.first)
      expect(parsed.celda).to eq(expected.last)
    end
  end

  it "leaves an unrecognized pavilion unchanged and leaves parsed pavilion unset" do
    parsed = described_class.new(Person.new(pabellon: "UNMAPPED"))

    expect(parsed.pabellon).to be_nil
    expect(parsed.celda).to eq("UNMAPPED")
  end
end
