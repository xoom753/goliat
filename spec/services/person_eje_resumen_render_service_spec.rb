require "rails_helper"

RSpec.describe PersonEjeResumenRenderService do
  let(:resumen) do
    PersonEjesResumen.new(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: delitos,
      sentencias: sentencias,
      acumulacion_penas: "12 años",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: periodos_detalle,
      tipo_porcentual: tipo_porcentual,
      fecha_traslado: fecha_traslado,
      ubicacion_traslado: ubicacion_traslado
    )
  end
  let(:delitos) { "Robo" }
  let(:sentencias) { "Sentencia A" }
  let(:periodos_detalle) do
    "02/01/20\t30/03/20\t90\t7,39%\n30/03/20\t30/06/20\t90\t20,00%\n\n01/07/20\t30/09/20\t90\t27,29%\n01/10/20\t31/12/20\t92\t40,00%"
  end
  let(:tipo_porcentual) { true }
  let(:fecha_traslado) { nil }
  let(:ubicacion_traslado) { nil }
  subject(:service) { described_class.new(resumen) }

  describe "#common_table_rows" do
    it "builds identity, detention, offense, and sentence rows" do
      expect(service.common_table_rows).to include(
        ["NOMBRE:", "CASEY EXAMPLE"],
        ["CÉDULA DE IDENTIDAD:", "1234567890"],
        ["FECHA DE PÉRDIDA DE LIBERTAD:", "02/01/2020"],
        ["DELITO:", "Robo"],
        ["SENTENCIA:", "Sentencia A"]
      )
    end

    it "adds a transfer row and includes its location when present" do
      allow(resumen).to receive(:fecha_traslado).and_return(Date.new(2022, 4, 5))
      allow(resumen).to receive(:ubicacion_traslado).and_return("Pabellón B")

      expect(service.common_table_rows).to include(["FECHA DE TRASLADO PABELLÓN B:", "05/04/2022"])
    end

    it "numbers multiple offenses and includes accumulated sentences" do
      allow(resumen).to receive(:delitos).and_return("Robo\nHurto")
      allow(resumen).to receive(:sentencias).and_return("Sentencia A\nSentencia B")

      expect(service.common_table_rows).to include(
        ["DELITO 1:", "Robo"],
        ["SENTENCIA 1:", "Sentencia A"],
        ["DELITO 2:", "Hurto"],
        ["SENTENCIA 2:", "Sentencia B"],
        ["ACUMULACIÓN DE PENAS:", "12 años"]
      )
    end

    it "memoizes the generated rows" do
      expect(
        service.common_table_rows.object_id
      ).to equal(service.common_table_rows.object_id)
    end
  end

  describe "#table_merged_rows_count" do
    it "accounts for identity, offenses, and non-percentage semester rows" do
      allow(resumen).to receive(:tipo_porcentual?).and_return(false)

      ##
      # NB its zero based:
      # rows:
      #  0 Nombre,
      #  1 Cédula,
      #  2 Fecha pérdida libertad,
      #  3 Delito,
      #  4 Sentencia
      #  5 Temporalidad
      expect(service.table_merged_rows_count).to eq(5)
    end

    it "accounts for identity, offenses, and non-percentage semester rows" do
      allow(resumen).to receive(:tipo_porcentual?).and_return(true)

      ##
      # NB its zero based:
      # rows:
      #  0 Nombre,
      #  1 Cédula,
      #  2 Fecha pérdida libertad,
      #  3 Delito,
      #  4 Sentencia
      expect(service.table_merged_rows_count).to eq(4)
    end

    it "includes transfer and accumulated-penalty rows for multiple offenses" do
      allow(resumen).to receive(:tipo_porcentual?).and_return(false)
      allow(resumen).to receive(:fecha_traslado).and_return(Date.new(2022, 4, 5))
      allow(resumen).to receive(:delitos_array).and_return(["Robo", "Hurto"])

      # rows:
      #  0 Nombre,
      #  1 Cédula,
      #  2 Fecha pérdida libertad,
      #  3 Fecha traslado,
      #  4 Delito1,
      #  5 Sentencia1,
      #  6 Delito2,
      #  7 Sentencia2,
      #  8 Acumulación de penas
      #  9 Temporalidad
      expect(service.table_merged_rows_count).to eq(9)
    end
  end

  describe "#semestres_detail_hash" do
    it "formats dates and milestone labels for the first percentage group" do
      expect(service.semestres_detail_hash.fetch("20%").first).to eq(
        start_date: "02/01/2020",
        end_date: "30/03/2020",
        percentage: "7,39%",
        semestre_str: "Primer semestre 0,00% al 7,39%"
      )
    end

    it "labels a subsequent period and starts the next percentage group at its first semester" do
      second_period = service.semestres_detail_hash.fetch("20%").last
      next_group = service.semestres_detail_hash.fetch("40%").first

      expect(second_period[:semestre_str]).to eq("Segundo semestre 7,40% al 20,00%")
      expect(next_group[:semestre_str]).to eq("Primer semestre 20,01% al 27,29%")
      expect(next_group[:start_date]).to eq("01/07/2020")
    end

    it "memoizes the detail hash" do
      expect(
        service.semestres_detail_hash.object_id
      ).to equal(service.semestres_detail_hash.object_id)
    end
  end

  describe "#periodos_porcentuales" do
    before do
      allow(resumen).to receive(:periodos_detalle).and_return(
        "02/01/20\t30/06/20\n01/07/20\t31/12/20"
      )
    end

    it "builds ranges by percentage from one row per milestone" do
      expect(service.periodos_porcentuales).to eq(
        "20%" => [{ start_date: "02/01/20", end_date: "30/06/20" }],
        "40%" => [{ start_date: "01/07/20", end_date: "31/12/20" }]
      )
    end

    it "memoizes the percentage ranges" do
      expect(service.periodos_porcentuales.object_id).to equal(service.periodos_porcentuales.object_id)
    end
  end
end
