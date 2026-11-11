require "rails_helper"

RSpec.describe PersonEjesResumen::FichaRendererService::GenericFichaRenderer do
  let(:summary) do
    PersonEjesResumen.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: delitos,
      sentencias: sentencias,
      acumulacion_penas: "12 años",
      fecha_traslado: Date.new(2022, 4, 5),
      ubicacion_traslado: "Pabellón B",
      tipo_porcentual: percentage_mode
    )
  end
  let(:delitos) { "Robo\nHurto" }
  let(:sentencias) { "Sentencia A\nSentencia B" }
  let(:percentage_mode) { false }
  let(:period) { double(periodos: []) }
  let(:docx) { double }
  let(:translator) { double(t: "translated") }
  let(:activities_renderer) { double }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      kind: :cultural,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      periodos_renderer_service: period,
      activities_by_periods_renderer_service: activities_renderer,
      index: 0
    )
  end

  describe "#common_table_rows" do
    it "builds identity, transfer, offense, sentence, and accumulated penalty rows" do
      rows = renderer.send(:common_table_rows)

      expect(rows).to include(
        ["NOMBRE:", "CASEY EXAMPLE"],
        ["CÉDULA DE IDENTIDAD:", "1234567890"],
        ["FECHA DE PÉRDIDA DE LIBERTAD:", "02/01/2020"],
        ["FECHA DE TRASLADO PABELLÓN B:", "05/04/2022"],
        ["DELITO 1:", "Robo"],
        ["SENTENCIA 1:", "Sentencia A"],
        ["DELITO 2:", "Hurto"],
        ["SENTENCIA 2:", "Sentencia B"],
        ["ACUMULACIÓN DE PENAS:", "12 años"]
      )
      expect(renderer.send(:common_table_rows)).to equal(rows)
    end

    it "uses a generic transfer date label when the location is blank" do
      allow(summary).to receive(:ubicacion_traslado).and_return(nil)

      expect(renderer.send(:common_table_rows)).to include(["FECHA DE TRASLADO:", "05/04/2022"])
    end
  end

  describe "#get_info_table_merged_rows_count" do
    it "counts transfer, multiple-offense, and semester rows" do
      expect(renderer.send(:get_info_table_merged_rows_count)).to eq(9)
    end

    it "omits transfer and multiple-offense adjustments for percentage reports with one offense" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)
      allow(summary).to receive(:fecha_traslado).and_return(nil)
      allow(summary).to receive(:delitos_array).and_return(["Robo"])
      allow(summary).to receive(:several_delitos?).and_return(false)

      expect(renderer.send(:get_info_table_merged_rows_count)).to eq(4)
    end
  end
end
