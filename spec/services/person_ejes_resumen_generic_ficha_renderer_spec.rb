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
      ubicacion_traslado: ubicacion_traslado,
      tipo_porcentual: percentage_mode
    )
  end
  let(:delitos) { "Robo\nHurto" }
  let(:sentencias) { "Sentencia A\nSentencia B" }
  let(:ubicacion_traslado) { "Pabellón B" }
  let(:percentage_mode) { false }
  let(:docx) { double }
  let(:translator) { double }
  let(:period) { double(periodos: [ double ]) }
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
    it "builds identity, transfer, offenses, sentences, and accumulated penalty rows" do
      rows = renderer.send(:common_table_rows)

      expect(rows).to include(
        [ "NOMBRES:", "CASEY EXAMPLE" ],
        [ "CÉDULA DE IDENTIDAD:", "1234567890" ],
        [ "FECHA DE PÉRDIDA DE LIBERTAD:", "02/01/2020" ],
        [ "FECHA DE TRASLADO PABELLÓN B:", "05/04/2022" ],
        [ "DELITO 1:", "Robo" ],
        [ "SENTENCIA 1:", "Sentencia A" ],
        [ "DELITO 2:", "Hurto" ],
        [ "SENTENCIA 2:", "Sentencia B" ],
        [ "ACUMULACIÓN DE PENAS:", "12 años" ]
      )
      expect(renderer.send(:common_table_rows)).to equal(rows)
    end

    it "omits transfer details when the transfer location is blank" do
      allow(summary).to receive(:ubicacion_traslado).and_return(nil)

      expect(renderer.send(:common_table_rows)).to include([ "FECHA DE TRASLADO:", "05/04/2022" ])
    end
  end

  describe "period-type renderer delegation" do
    it "builds and memoizes a semester renderer" do
      allow(summary).to receive(:tipo_porcentual?).and_return(false)
      renderer.send(:by_tipo_periodo_renderer)
      period_type_renderer = renderer.instance_variable_get(:@by_tipo_periodo_renderer)

      expect(period_type_renderer).to be_a(PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosSemestralesRenderer)
      expect(renderer.send(:by_tipo_periodo_renderer)).to equal(period_type_renderer)
    end

    it "builds a percentage renderer for percentage-based summaries" do
      allow(summary).to receive(:tipo_porcentual?).and_return(true)

      expect(renderer.send(:by_tipo_periodo_renderer)).to be_a(PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosPorcentualesRenderer)
    end
  end
end
