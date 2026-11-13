require "rails_helper"

RSpec.describe PersonActivity, type: :model do
  it "belongs to a person and a polymorphic coursable" do
    expect(described_class.reflect_on_association(:person).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:coursable).options[:polymorphic]).to be(true)
  end

  it "sorts oldest records first by year and month" do
    earlier = described_class.create!(person: Person.create!(nombres: "Earlier"), coursable: ExtraActivity.create!(nombre: "Course"), anio: 2023, mes: 12)
    later = described_class.create!(person: Person.create!(nombres: "Later"), coursable: ExtraActivity.create!(nombre: "Course"), anio: 2024, mes: 1)

    expect(described_class.oldest_first).to eq([earlier, later])
  end

  it "returns the last day of its month as the end date" do
    activity = described_class.new(anio: 2024, mes: 2)

    expect(activity.end_date).to eq(Date.new(2024, 2, 29))
  end

  it "returns the last day for a non-leap February" do
    activity = described_class.new(anio: 2023, mes: 2)

    expect(activity.end_date).to eq(Date.new(2023, 2, 28))
  end

  it "maps cargo values to their integer-backed enum" do
    expect(described_class.cargos).to include(
      "estudiante" => 0,
      "instructor" => 1,
      "apoyo" => 2,
      "independiente" => 3,
      "responsable" => 4,
      "cuentapropia" => 5
    )
  end
end
