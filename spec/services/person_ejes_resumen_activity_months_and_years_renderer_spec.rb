require "rails_helper"

RSpec.describe PersonEjesResumen::ActivityToHumanRendererService::ActivityMonthsAndYearsRenderer do
  describe "#meses_y_anios_str" do
    it "formats a single month and optionally uppercases the month" do
      renderer = described_class.new(by_months: { Date.new(2024, 1, 31) => :activity })

      expect(renderer.meses_y_anios_str).to eq("enero de 2024")
      expect(renderer.meses_y_anios_str(upcase: true)).to eq("ENERO de 2024")
    end

    it "joins multiple months in one year with y" do
      renderer = described_class.new(by_months: {
        Date.new(2024, 1, 31) => :jan,
        Date.new(2024, 3, 31) => :mar
      })

      expect(renderer.meses_y_anios_str).to eq("enero y marzo de 2024")
    end

    it "includes years for ranges crossing calendar years" do
      renderer = described_class.new(by_months: {
        Date.new(2023, 11, 30) => :nov,
        Date.new(2024, 1, 31) => :jan,
        Date.new(2024, 2, 29) => :feb
      })

      expect(renderer.meses_y_anios_str).to eq("noviembre de 2023, enero de 2024 y febrero de 2024")
    end

    it "sorts the months chronologically regardless of hash insertion order" do
      renderer = described_class.new(by_months: {
        Date.new(2024, 3, 31) => :mar,
        Date.new(2024, 1, 31) => :jan,
        Date.new(2024, 2, 29) => :feb
      })

      expect(renderer.meses_y_anios_str).to eq("enero, febrero y marzo de 2024")
    end
  end
end
