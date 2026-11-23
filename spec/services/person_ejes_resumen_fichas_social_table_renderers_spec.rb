require "rails_helper"

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoActualRenderer do
  let(:docx) { double }
  let(:summary) { double(tipo_porcentual?: percentage_mode) }
  let(:periods) { [ double(period_percentage: "20%"), double(period_percentage: "40%") ] }
  let(:percentage_mode) { true }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      semestre: "20%",
      person_ejes_resumen: summary,
      periodos: periods
    )
  end

  before do
    allow(I18n).to receive(:t).and_call_original
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.permanente_disciplina").and_return("Permanent discipline")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.permanente_respeto").and_return("Permanent respect")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.permanente_comportamiento").and_return("Permanent behavior")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.temporal_capacitaciones").and_return("Temporary training")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.temporal_participacion").and_return("Temporary participation")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.permanente_apoyo").and_return("Permanent support")
    allow(I18n).to receive(:t).with("person_ejes_resumen.social_report.permanente_participacion").and_return("Permanent participation")
    allow(docx).to receive(:table) { |rows, &_block| rows }
  end

  it "renders a score column for every percentage period" do
    expect(renderer.table).to eq([
      [ "ACTIVIDADES", "DETALLES DE ACTIVIDADES", "PUNTAJE", "20%", "40%", "JUSTIFICACIÓN DE LA CALIFICACIÓN" ],
      [ "Permanent discipline", "Permanent respect", "0,50 puntos", "0,50", "0,50", "Sí cumple" ],
      [ "Permanent discipline", "Permanent behavior", "0,50 puntos", "0,50", "0,50", "Sí cumple" ],
      [ "Temporary training", "Temporary participation", "0,50 puntos", "0,25", "0,25", "Charlas motivacionales individuales" ],
      [ "Permanent support", "Permanent participation", "0,50 puntos", "0,25", "0,25", "Orientaciones psicológicas grupales" ]
    ])
  end

  it "renders semester-mode scores in a single period column" do
    allow(summary).to receive(:tipo_porcentual?).and_return(false)

    expect(renderer.table).to eq([
      [ "ACTIVIDADES", "DETALLES DE ACTIVIDADES", "PUNTAJE", "20%", "JUSTIFICACIÓN DE LA CALIFICACIÓN" ],
      [ "Permanent discipline", "Permanent respect", "0,50 puntos", "0,50", "Sí cumple" ],
      [ "Permanent discipline", "Permanent behavior", "0,50 puntos", "0,50", "Sí cumple" ],
      [ "Temporary training", "Temporary participation", "2 puntos", "1", "Charlas motivacionales individuales" ],
      [ "Permanent support", "Permanent participation", "2 puntos", "1", "Orientaciones psicológicas grupales" ]
    ])
  end
end

RSpec.describe PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoAntiguoRenderer do
  let(:docx) { double }

  it "preserves the legacy social table and its merged area columns" do
    expect(docx).to receive(:table) do |rows, &_block|
      expect(rows.first).to eq([ "ÁREAS", "PARÁMETROS", "PUNTUACIÓN", "CALIFICACIÓN", "TOTAL POR ÁREA" ])
      expect(rows.length).to eq(6)
      rows
    end

    table = described_class.new(docx: docx).table

    expect(table[1]).to eq([
      "RELACIONES INTERPERSONALES - 2,5 PUNTOS",
      "Asistencia a terapias individuales o grupales",
      "0,50",
      "0,50",
      "2,5"
    ])
  end
end
