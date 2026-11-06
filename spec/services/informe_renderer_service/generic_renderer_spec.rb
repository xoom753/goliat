require "rails_helper"

RSpec.describe InformeRendererService::GenericRenderer do
  let(:report) do
    double(
      docx: double,
      kind: :cultural,
      person_ejes_renderer: double(nombres: "Casey Example"),
      legacy_person_activities_by_date: {},
      tipo_porcentual?: false,
      periodos_porcentuales: {},
      get_first_period: nil
    )
  end
  subject(:renderer) { described_class.new(report) }

  it "includes temporalidad and date bounds for a non-percentage report" do
    renderer.semestre = "Primer semestre"
    renderer.period = { start_date: "01/01/2024", end_date: "30/06/2024" }

    expect(renderer.ficha_info_table_bottom_rows).to eq([
      ["TEMPORALIDAD", "Primer semestre"],
      ["SEMESTRE", "01/01/2024", "30/06/2024"]
    ])
  end

  it "omits semester rows for percentage-based reports" do
    allow(report).to receive(:tipo_porcentual?).and_return(true)

    expect(renderer.ficha_info_table_bottom_rows).to eq([])
  end

  it "selects activities whose end dates are within the selected period" do
    start_date = Date.new(2024, 1, 1)
    included_date = Date.new(2024, 3, 31)
    end_date = Date.new(2024, 6, 30)
    included_activity = double("included activity", year: 2024, activity: :course, month: 3)
    excluded_activity = double("excluded activity", year: 2024, activity: :other_course, month: 7)
    allow(report).to receive(:legacy_person_activities_by_date).and_return(
      start_date - 1 => [:before],
      included_date => [included_activity],
      end_date + 1 => [excluded_activity]
    )
    renderer.period = { start_date: "01/01/2024", end_date: "30/06/2024" }
    allow(InformeRendererService::ActivitiesGroupedRenderer).to receive(:new).with([included_activity]).and_return(
      double(grouped_activities: [:included])
    )

    expect(renderer.get_activities_within_period).to eq([:included])
  end

  it "selects the full percentage range from the first period to the final period" do
    allow(report).to receive(:tipo_porcentual?).and_return(true)
    allow(report).to receive(:get_first_period).and_return(
      start_date: "01/01/2024",
      end_date: "30/06/2024"
    )
    allow(report).to receive(:periodos_porcentuales).and_return(
      "20%" => [{ start_date: "01/01/2024", end_date: "30/06/2024" }],
      "40%" => [{ start_date: "01/07/2024", end_date: "31/12/2024" }]
    )
    activity = double("percentage activity", year: 2024, activity: :course, month: 6)
    allow(report).to receive(:legacy_person_activities_by_date).and_return(
      Date.new(2023, 12, 31) => [:before],
      Date.new(2024, 6, 30) => [activity],
      Date.new(2025, 1, 1) => [:after]
    )
    allow(InformeRendererService::ActivitiesGroupedRenderer).to receive(:new).with([activity]).and_return(
      double(grouped_activities: [:selected])
    )

    expect(renderer.get_activities_within_period).to eq([:selected])
  end

  it "builds qualification table rows for every percentage period" do

    allow(report).to receive(:tipo_porcentual?).and_return(true)
    allow(report).to receive(:periodos_porcentuales).and_return(
      "20%" => [{ start_date: "01/01/2024", end_date: "30/06/2024" }],
      "40%" => [{ start_date: "01/07/2024", end_date: "31/12/2024" }]
    )

    expect(renderer.ficha_qualy_bottom_rows).to eq([
      ["PERIODO 20%", "01/01/2024", "30/06/2024"],
      ["PERIODO 40%", "01/07/2024", "31/12/2024"]
    ])
  end

  it "builds qualification table rows for the selected semester" do
    renderer.period = {
      semestre_str: "Primer semestre",
      start_date: "01/01/2024",
      end_date: "30/06/2024"
    }

    expect(renderer.ficha_qualy_bottom_rows).to eq([
      ["PRIMER SEMESTRE", "01/01/2024", "30/06/2024"]
    ])
  end
end
