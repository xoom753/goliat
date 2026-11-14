require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer do
  let(:current_period) { double(period_percentage: "20%", activities: [:activity]) }
  let(:later_period) { double(period_percentage: "40%", activities: []) }
  let(:periods) { [current_period, later_period] }
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:by_tipo_periodo_renderer) do
    double(
      get_kind_specific_table_header_colspan: 5,
      get_semestre: "20%",
      get_subtotal_max_grade: "2",
      concat_tipo_porcentual_rows!: nil
    )
  end
  let(:docx) { double }
  let(:percentage_mode) { true }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      current_periodo: current_period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      by_tipo_periodo_renderer: by_tipo_periodo_renderer
    )
  end

  it "returns the temporal grade based on current-period activity presence" do
    expect(renderer.send(:temp_grade)).to eq("2")
    allow(current_period).to receive(:activities).and_return([])
    expect(renderer.send(:temp_grade)).to eq("0")
  end

  it "delegates the grade-table header span to the period-type renderer" do
    expect(renderer.send(:get_kind_specific_table_header_colspan)).to eq(5)
  end

  it "renders grades tables and applies semester cell styling" do
    renderer_class = Class.new(described_class) do
      private

      def grades_table_rows_first_part
        [["Axis"], ["Header", "Max", "20%"]]
      end

      def grades_table_permanente_rows
        [["Permanent", "Description", "Parameter", "3", "0", "0", "0", "0"]]
      end

      def grades_table_rows_last_part
        [["Temporal", "Description", "Parameter", "2", "0", "0", "0", "0"], ["Subtotal", "5", "0", "0", "0", "0"]]
      end
    end
    allow(summary).to receive(:tipo_porcentual?).and_return(false)
    table_renderer = renderer_class.new(
      docx: docx,
      current_periodo: current_period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: periods),
      by_tipo_periodo_renderer: by_tipo_periodo_renderer
    )
    allow(table_renderer).to receive(:column_widths)
    allow(table_renderer).to receive(:border_size)
    allow(table_renderer).to receive(:cell_style)
    allow(table_renderer).to receive(:cols).and_return([:first_column])
    allow(table_renderer).to receive(:rows).and_return(Array.new(6) { Array.new(8) { :cell } })
    allow(table_renderer).to receive(:cells).and_return(:all_cells)
    allow(docx).to receive(:p)
    allow(docx).to receive(:table) { |&block| table_renderer.instance_exec(&block) }

    expect(table_renderer).to receive(:cell_style).with(:first_column, bold: true)
    expect(table_renderer).to receive(:cell_style).with(:cell, align: :center, bold: true, vertical_align: :center)

    table_renderer.grades_table
  end
end
