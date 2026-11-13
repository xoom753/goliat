require "rails_helper"

RSpec.describe ImportError, type: :model do
  let(:details) do
    {
      "nombres" => "Casey Example",
      "dni" => "1234567890",
      "cargo" => "Instructor",
      "activity" => "Workshop"
    }
  end

  it "serializes details_object to YAML before saving" do
    record = described_class.create!(details_object: details)

    expect(record.details).to include("nombres:", "Casey Example")
    expect(record.reload.details_object).to eq(details)
  end

  it "loads details_object from stored YAML details" do
    record = described_class.create!(details: details.to_yaml)

    expect(record.details_object).to eq(details)
  end

  it "memoizes deserialized details_object values" do
    record = described_class.create!(details: details.to_yaml)
    first_result = record.details_object

    expect(record.details_object).to equal(first_result)
  end

  it "preserves nested details when serializing and loading" do
    nested_details = {
      "person" => { "nombres" => "Casey Example", "dni" => "1234567890" },
      "period" => { "mes" => "3", "anio" => "2024" }
    }
    record = described_class.create!(details_object: nested_details)

    expect(record.reload.details_object).to eq(nested_details)
  end
end
