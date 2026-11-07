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

  describe "#ficha_info_summary" do
    it "renders the successful summary when activities exist" do
      allow(renderer).to receive(:get_activities_within_period).and_return([:activity])
      expect(renderer).to receive(:ficha_info_summary_si_cumple)

      renderer.ficha_info_summary
    end

    it "renders the unsuccessful summary when no activities exist" do
      allow(renderer).to receive(:get_activities_within_period).and_return([])
      expect(renderer).to receive(:ficha_info_summary_no_cumple)

      renderer.ficha_info_summary
    end
  end

  describe "#ficha_qualy_summary" do
    it "renders the successful qualification summary when activities exist" do
      allow(renderer).to receive(:get_activities_within_period).and_return([:activity])
      expect(renderer).to receive(:ficha_qualy_summary_si_cumple)

      renderer.ficha_qualy_summary
    end

    it "renders the unsuccessful qualification summary when no activities exist" do
      allow(renderer).to receive(:get_activities_within_period).and_return([])
      expect(renderer).to receive(:ficha_qualy_summary_no_cumple)

      renderer.ficha_qualy_summary
    end
  end

  describe "#ficha_info_actividades" do
    before do
      allow(report.docx).to receive(:p)
      allow(report.docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
      allow(renderer).to receive(:c_t).with("act_permanente").and_return("CULTURAL PERMANENTE:")
      allow(renderer).to receive(:c_t)
        .with("no_registra_permanente", downcase: true, kind_f: true)
        .and_return("No registra actividad cultural permanente en este periodo.")
      allow(renderer).to receive(:c_t).with("act_temporal").and_return("CULTURAL TEMPORAL:")
      allow(renderer).to receive(:c_t)
        .with("no_registra_temporal", downcase: true, kind_f: true)
        .and_return("no registra actividad cultural temporal en este periodo.")
    end

    it "lists each certificate when activities exist" do
      activity = double(cert_string: "Por participar en el curso")
      allow(renderer).to receive(:get_activities_within_period).and_return([activity])
      expect(renderer).to receive(:li).with("No registra actividad cultural permanente en este periodo.")
      expect(renderer).to receive(:li).with("Por participar en el curso.")

      renderer.ficha_info_actividades
    end

    it "lists the no-activity message for the selected period" do
      allow(renderer).to receive(:get_activities_within_period).and_return([])
      expect(renderer).to receive(:li).with("No registra actividad cultural permanente en este periodo.")
      expect(renderer).to receive(:li).with("no registra actividad cultural temporal en este periodo.")

      renderer.ficha_info_actividades
    end
  end

  describe "summary text" do
    let(:text_runs) { [] }

    before do
      allow(report.docx).to receive(:p) do |*arguments, &block|
        renderer.instance_exec(&block) if block
      end
      allow(renderer).to receive(:text) { |text, **_options| text_runs << text }
    end

    it "writes the successful information summary with the person name and affirmative status" do
      allow(renderer).to receive(:c_t) do |key, **options|
        I18n.t("common.#{key}", **options.merge(kind_str: "Cultural"))
      end

      renderer.send(:ficha_info_summary_si_cumple)

      expect(text_runs.join).to include("Se informa que la PPL. ", "CASEY EXAMPLE", "SÍ", "cumple con el proceso")
    end

    it "writes the successful qualification summary with an affirmative status" do
      allow(renderer).to receive(:c_t) do |key, **options|
        I18n.t("common.#{key}", **options.merge(kind_str: "Cultural"))
      end

      renderer.send(:ficha_qualy_summary_si_cumple)

      expect(text_runs.join).to include("Observaciones:", "SÍ", "cumple con el Eje Cultural")
    end
  end

  describe "#get_period_range" do
    it "uses the selected semester dates for a non-percentage report" do
      renderer.period = { start_date: "01/01/2024", end_date: "30/06/2024" }

      expect(renderer.send(:get_period_range)).to eq(Date.new(2024, 1, 1)..Date.new(2024, 6, 30))
    end

    it "uses the first and final percentage dates for a percentage report" do
      allow(report).to receive(:tipo_porcentual?).and_return(true)
      allow(report).to receive(:get_first_period).and_return(
        start_date: "01/01/2024", end_date: "30/06/2024"
      )
      allow(report).to receive(:periodos_porcentuales).and_return(
        "20%" => [{ start_date: "01/01/2024", end_date: "30/06/2024" }],
        "40%" => [{ start_date: "01/07/2024", end_date: "31/12/2024" }]
      )

      expect(renderer.send(:get_period_range)).to eq(Date.new(2024, 1, 1)..Date.new(2024, 12, 31))
    end
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
