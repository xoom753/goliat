require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer do
  let(:period) { double(period_percentage: "20%", activities: []) }
  let(:summary) { double(tipo_porcentual?: false) }
  let(:period_type_renderer) do
    double(
      get_kind_specific_table_header_colspan: 4,
      get_semestre: "20%",
      get_subtotal_max_grade: "5",
      concat_tipo_porcentual_rows!: nil
    )
  end
  let(:docx) { double }
  let(:renderer_class) do
    Class.new(described_class) do
      private

      def grades_table_rows_first_part
        [["Axis"], ["Header", "Max", "20%"]]
      end

      def grades_table_permanente_rows
        [["Permanent", "Description", "3", "0", "0", "0", "0", "0"]]
      end

      def grades_table_rows_last_part
        [["Temporal", "Description", "2", "0", "0", "0", "0", "0"], ["Subtotal", "5", "0", "0", "0", "0"]]
      end
    end
  end
  subject(:renderer) do
    renderer_class.new(
      docx: docx,
      current_periodo: period,
      person_ejes_resumen: summary,
      periodos_renderer_service: double(periodos: [period]),
      by_tipo_periodo_renderer: period_type_renderer
    )
  end

  it "applies permanent, temporal, and subtotal cell styles in semester mode" do
    cells = Array.new(8) { |index| "cell-#{index}" }
    rows = [Array.new(1, "header"), Array.new(5, "header-cell"), cells, cells, cells]
    allow(renderer).to receive(:rows).and_return(rows)
    allow(renderer).to receive(:cols).and_return([:first_column])
    allow(renderer).to receive(:cells).and_return(:all_cells)
    allow(renderer).to receive(:column_widths)
    allow(renderer).to receive(:border_size)
    allow(docx).to receive(:table) { |&block| renderer.instance_exec(&block) }
    allow(docx).to receive(:p)
    expect(renderer).to receive(:cell_style).with(:cell-0, align: :center, bold: true, vertical_align: :center)
    expect(renderer).to receive(:cell_style).with(:cell-7, align: :center, vertical_align: :center)

    renderer.grades_table
  end
end
