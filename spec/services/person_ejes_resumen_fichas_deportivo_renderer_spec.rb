require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasDeportivoRenderer do
  let(:person_summary) { double(tipo_porcentual?: percentage_mode) }
  let(:period) do
    double(
      period_percentage: "20%",
      activities: activities,
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 6, 30)
    )
  end
  let(:periods) { [period] }
  let(:docx) { double }
  let(:percentage_mode) { false }
  let(:activities) { [] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      person_ejes_resumen: person_summary,
      periodos_renderer_service: double(periodos: periods),
      current_periodo: period
    )
  end

  it "uses the current semester period percentage for semester mode" do
    rows = renderer.send(:grades_table_rows)

    expect(rows[1].last).to eq("20%")
  end

  it "uses the first report period percentage for percentage mode" do
    allow(person_summary).to receive(:tipo_porcentual?).and_return(true)
    first_period = double(period_percentage: "20%", activities: [])
    second_period = double(period_percentage: "40%", activities: [])
    allow(renderer).to receive(:periodos).and_return([first_period, second_period])

    rows = renderer.send(:grades_table_rows)

    expect(rows[1].last).to eq("20%")
  end

  it "assigns zero temporal points to an empty period" do
    expect(renderer.send(:grades_table_rows)[3].last).to eq("0")
  end

  it "assigns two temporal points when the period contains activities" do
    allow(period).to receive(:activities).and_return([:activity])

    expect(renderer.send(:grades_table_rows)[3].last).to eq("2")
  end
end
