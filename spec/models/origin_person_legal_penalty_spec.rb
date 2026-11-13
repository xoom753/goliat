require "rails_helper"

RSpec.describe OriginPersonLegalPenalty, type: :model do
  let(:origin_person) do
    OriginPerson.create!(
      fecha_registro: Date.new(2025, 1, 1),
      father_lastname: "Pérez",
      first_name: "Ana"
    )
  end

  let(:legal_process) { OriginPersonLegalProcess.create!(origin_person: origin_person) }

  it "converts supplied sentence values before saving" do
    penalty = described_class.new(origin_person: origin_person, origin_person_legal_process: legal_process)
    penalty.cantidad_total_sentencia_str = "120"
    penalty.termina_condena_at_str = "2030-12-31"
    penalty.veinte_porciento_at_str = "2026-01-01"

    penalty.save!

    expect(penalty.cantidad_total_sentencia).to eq(120)
    expect(penalty.termina_condena_at).to eq(Date.new(2030, 12, 31))
    expect(penalty.veinte_porciento_at).to eq(Date.new(2026, 1, 1))
  end

  it "converts each supplied percentage date before saving" do
    penalty = described_class.new(origin_person: origin_person, origin_person_legal_process: legal_process)
    penalty.cuarenta_porciento_at_str = "2025-01-15"
    penalty.sesenta_porciento_at_str = "2026-01-15"
    penalty.ochenta_porciento_at_str = "2027-01-15"

    penalty.save!

    expect(penalty.cuarenta_porciento_at).to eq(Date.new(2025, 1, 15))
    expect(penalty.sesenta_porciento_at).to eq(Date.new(2026, 1, 15))
    expect(penalty.ochenta_porciento_at).to eq(Date.new(2027, 1, 15))
  end

  it "leaves values unchanged when their input is EN PROCESO" do
    penalty = described_class.new(origin_person: origin_person, origin_person_legal_process: legal_process)
    penalty.cantidad_total_sentencia = 90
    penalty.cantidad_total_sentencia_str = described_class::EN_PROCESO
    penalty.termina_condena_at = Date.new(2030, 12, 31)
    penalty.termina_condena_at_str = described_class::EN_PROCESO

    penalty.save!

    expect(penalty.cantidad_total_sentencia).to eq(90)
    expect(penalty.termina_condena_at).to eq(Date.new(2030, 12, 31))
  end
end
