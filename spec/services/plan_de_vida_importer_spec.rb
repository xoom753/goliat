require "rails_helper"

RSpec.describe PlanDeVidaImporter do
  let(:sheet) { double }
  let(:workbook) { double(sheet: sheet) }
  subject(:importer) { described_class.new("plan.xlsx") }

  before do
    # not used
    # allow(Roo::Spreadsheet).to receive(:open).with("plan.xlsx", extension: :xlsx).and_return(workbook)
  end

  pending "opens the individual report sheet" do
    expect(workbook).to receive(:sheet).with("REPORTE INDIVIDUAL")

    described_class.new("plan.xlsx")
  end

  pending "skips the header and blank-name rows and saves named activity rows" do
    first_record = instance_double(LegacyPersonActivity)
    second_record = instance_double(LegacyPersonActivity)
    allow(sheet).to receive(:each).and_yield({}).and_yield(
      num: 1,
      nombres: "  ANA PEREZ  ",
      servicios: "Grupo",
      actividad: "Actividad",
      fecha: "  marzo 2024  ",
      duracion: "8"
    ).and_yield(
      num: 2,
      nombres: nil,
      servicios: "Grupo",
      actividad: "Actividad",
      fecha: "marzo 2024",
      duracion: "3"
    ).and_yield(
      num: 3,
      nombres: "LUIS LOPEZ",
      servicios: "Grupo",
      actividad: "Actividad",
      fecha: "abril 2024",
      duracion: "5"
    )
    expect(LegacyPersonActivity).to receive(:new).with(
      row_number: 1,
      nombres: "ANA PEREZ",
      activity_group_str: "Grupo",
      activity_str: "Actividad",
      activity_dates: "marzo 2024",
      duracion: "8"
    ).and_return(first_record)
    expect(LegacyPersonActivity).to receive(:new).with(
      row_number: 3,
      nombres: "LUIS LOPEZ",
      activity_group_str: "Grupo",
      activity_str: "Actividad",
      activity_dates: "abril 2024",
      duracion: "5"
    ).and_return(second_record)
    expect(first_record).to receive(:save!).once
    expect(second_record).to receive(:save!).once

    importer.rows_hash
  end
end
