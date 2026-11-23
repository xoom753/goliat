require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::GradesFichaRenderer do
  let(:period) { double(activities: activities, semestre_str: "Primer semestre", start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 6, 30)) }
  let(:period_renderer) { double(periodos: [ period ]) }
  let(:docx) { double }
  let(:summary) { double(tipo_porcentual?: false) }
  let(:translator) { double }
  let(:activities_renderer) { double }
  let(:activities) { [ :activity ] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      kind: :cultural,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      periodos_renderer_service: period_renderer,
      activities_by_periods_renderer_service: activities_renderer,
      index: 0
    )
  end

  describe "#should_render_grades_ficha?" do
    it "does not render for an old-format period" do
      allow(period).to receive(:is_formato_antiguo?).and_return(true)

      expect(renderer.should_render_grades_ficha?).to be(false)
    end

    it "renders for a current-format period" do
      allow(period).to receive(:is_formato_antiguo?).and_return(false)

      expect(renderer.should_render_grades_ficha?).to be(true)
    end
  end

  describe "titles and introduction" do
    it "renders translated headings and intro text" do
      allow(translator).to receive(:stringify) do |key, **_options|
        key.upcase
      end
      expect(docx).to receive(:h1).with("COMMON.QUALY_MAIN_TITLE", align: :center)
      expect(docx).to receive(:h1).with("COMMON.QUALY_MAIN_SUBTITLE", align: :center)
      expect(docx).to receive(:h1).with("COMMON.QUALY_MAIN_TABLE_TITLE", align: :center)
      expect(docx).to receive(:p).with("COMMON.QUALY_DATOS", bold: true).ordered
      expect(docx).to receive(:p).with(no_args).exactly(3).times

      renderer.title
      renderer.intro
      renderer.grades_table_title
    end
  end

  it "renders its info table and applies merged-cell styling" do
    allow(translator).to receive(:stringify).and_return("translated")
    allow(renderer).to receive(:common_table_rows).and_return([ [ "NAME", "CASEY" ], [ "OFFENSE", "ROBO" ] ])
    allow(renderer).to receive(:grades_ficha_bottom_rows).and_return([ [ "PERIOD", "DATE", "DATE" ] ])
    allow(renderer).to receive(:get_grades_table_merged_rows_count).and_return(1)
    allow(renderer).to receive(:cols).and_return([ [ "first-column" ] ])
    allow(renderer).to receive(:rows).and_return([ [ "r0c0", "r0c1" ], [ "r1c0", "r1c1" ] ])
    allow(renderer).to receive(:cells).and_return(:all_cells)
    allow(renderer).to receive(:cell_style)
    allow(renderer).to receive(:column_widths)
    allow(renderer).to receive(:border_size)
    allow(docx).to receive(:p)
    expect(docx).to receive(:table).with([ [ "NAME", "CASEY" ], [ "OFFENSE", "ROBO" ], [ "PERIOD", "DATE", "DATE" ] ]) do |rows, &block|
      renderer.instance_exec(&block)
    end
    expect(renderer).to receive(:cell_style).with([ "first-column" ], bold: true)
    expect(renderer).to receive(:cell_style).with("r0c1", colspan: 2)
    expect(renderer).to receive(:cell_style).with("r1c1", colspan: 2)

    renderer.info_table
  end

  describe "#grades_summary" do
    it "renders the success branch when the period has activities" do
      allow(docx).to receive(:p)
      expect(renderer).to receive(:grades_si_cumple)

      renderer.grades_summary
    end

    it "renders the success branch when a percentage report has activities in any period" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      allow(period_renderer).to receive(:periodos).and_return([ period, double(activities: [ :activity ]) ])
      period_type_renderer = double(has_any_activity?: true)
      allow(renderer).to receive(:by_tipo_periodo_renderer).and_return(period_type_renderer)
      allow(docx).to receive(:p)
      expect(renderer).to receive(:grades_si_cumple)

      renderer.grades_summary
    end

    it "renders the no-activity branch when the period is empty" do
      allow(docx).to receive(:p)
      allow(period).to receive(:activities).and_return([])
      expect(renderer).to receive(:grades_no_cumple)

      renderer.grades_summary
    end
  end
end
