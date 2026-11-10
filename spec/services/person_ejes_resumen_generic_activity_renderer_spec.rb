require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityRendererService::GenericActivityRenderer do
  let(:activity) { double(end_date: Date.new(2024, 3, 31)) }
  subject(:renderer) { described_class.new(current_activity: activity) }

  it "delegates end_date to the wrapped activity" do
    expect(renderer.end_date).to eq(Date.new(2024, 3, 31))
  end

  describe "#get_duracion_h" do
    it "uses the default duration when the value is nil" do
      expect(renderer.send(:get_duracion_h, nil)).to eq(30)
    end

    it "parses an hours string into an integer" do
      expect(renderer.send(:get_duracion_h, "12 HORAS")).to eq(12)
    end

    it "returns zero when the value does not contain a number" do
      expect(renderer.send(:get_duracion_h, "sin duración")).to eq(0)
    end
  end
end
