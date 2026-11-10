require "rails_helper"

RSpec.describe PersonEjesResumen::PeriodosWrapper::GenericWrapper do
  describe "#include?" do
    it "includes boundary dates and excludes dates outside its range" do
      wrapper = PersonEjesResumen::PeriodosWrapper::PorcentualWrapper.new(
        kind: :cultural,
        start_date: "01/01/2024",
        end_date: "31/03/2024",
        period_percentage: "20%"
      )

      expect(wrapper.include?(Date.new(2024, 1, 1))).to be(true)
      expect(wrapper.include?(Date.new(2024, 3, 31))).to be(true)
      expect(wrapper.include?(Date.new(2024, 4, 1))).to be(false)
    end
  end

  describe "#append and #activities" do
    it "groups appended activities by activity name" do
      wrapper = PersonEjesResumen::PeriodosWrapper::PorcentualWrapper.new(
        kind: :cultural,
        start_date: "01/01/2024",
        end_date: "31/03/2024",
        period_percentage: "20%"
      )
      first = double(activity_nombre: "Weaving", end_date: Date.new(2024, 1, 31), duracion_i: 2)
      repeated = double(activity_nombre: "Weaving", end_date: Date.new(2024, 2, 29), duracion_i: 3)
      other = double(activity_nombre: "Painting", end_date: Date.new(2024, 3, 31), duracion_i: 4)

      wrapper.append(first)
      wrapper.append(repeated)
      wrapper.append(other)

      expect(wrapper.activities.map(&:activity_str)).to contain_exactly("Weaving", "Painting")
      expect(wrapper.activities.find { |activity| activity.activity_str == "Weaving" }.duracion_str).to eq("5 horas")
    end
  end

  it "formats wrapper dates for display" do
    wrapper = PersonEjesResumen::PeriodosWrapper::PorcentualWrapper.new(
      kind: :cultural,
      start_date: "02/01/2024",
      end_date: "31/03/2024",
      period_percentage: "20%"
    )

    expect(wrapper.start_date_str).to eq("02/01/2024")
    expect(wrapper.end_date_str).to eq("31/03/2024")
  end
end
