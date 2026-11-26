require "rails_helper"

RSpec.describe LegacyCourseFileParserService::LegacyPersonActivityBuilder do
  let(:parser) do
    double(
      nombres_col: 0,
      month_name_in_each_sheet?: true
    )
  end
  let(:import_file) { double(id: 42) }
  let(:params) do
    {
      grupo: " laboral ",
      actividad: " electricidad ",
      rango: nil,
      duracion: "8 horas",
      desde: nil,
      hasta: nil,
      detalle: nil
    }
  end
  subject(:builder) do
    described_class.new(
      row: [ "ANA PEREZ (Ingresa)" ],
      params: params,
      sheet_name: "marzo G1 2024",
      current_row_n: 3,
      legacy_import_file: import_file,
      legacy_course_file_parser: parser
    )
  end

  it "derives activity dates and month boundaries from the sheet name" do
    activity = builder.build_legacy_person_activity

    expect(activity).to have_attributes(
      row_number: 4,
      nombres_str: "Ana Perez",
      activity_group_str: "Laboral",
      activity_str: "Electricidad",
      activity_dates: "Marzo G1 2024",
      start_date: Date.new(2024, 3, 1),
      end_date: Date.new(2024, 3, 31),
      legacy_import_file_id: 42
    )
  end

  it "uses explicit dates and the provided date range" do
    allow(parser).to receive(:month_name_in_each_sheet?).and_return(false)
    params[:rango] = " febrero a abril "
    params[:desde] = Date.new(2024, 2, 1)
    params[:hasta] = Date.new(2024, 4, 30)

    activity = builder.build_legacy_person_activity

    expect(activity.activity_dates).to eq("Febrero A Abril")
    expect(activity.start_date).to eq(Date.new(2024, 2, 1))
    expect(activity.end_date).to eq(Date.new(2024, 4, 30))
  end

  it "normalizes an optional activity detail when present" do
    params[:detalle] = " electricidad básica "

    expect(builder.build_legacy_person_activity.activity_detail_str).to eq("Electricidad Básica")
  end

  it "returns no derived date values when the sheet has no month and no explicit dates" do
    allow(parser).to receive(:month_name_in_each_sheet?).and_return(false)

    activity = builder.build_legacy_person_activity

    expect(activity.start_date).to be_nil
    expect(activity.end_date).to be_nil
  end
end
