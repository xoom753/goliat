require "rails_helper"

RSpec.describe PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosPorcentualesRenderer do
  let(:docx) { double }
  let(:first_period) do
    double(
      period_percentage: "20%",
      start_date_str: "01/01/2024",
      end_date_str: "30/06/2024",
      activities: []
    )
  end
  let(:second_period) do
    double(
      period_percentage: "40%",
      start_date_str: "01/07/2024",
      end_date_str: "31/12/2024",
      activities: later_activities
    )
  end
  let(:periods) { [ first_period, second_period ] }
  let(:later_activities) { [] }
  let(:summary) do
    double(
      several_delitos?: false,
      fecha_traslado: nil,
      delitos_array: [ "Robo" ]
    )
  end
  let(:translator) { double(stringify: "Texto traducido") }
  let(:activity_renderer) { double(render_string: "Certificado") }
  let(:activities_renderer) { double(grouped_activities: grouped_activities) }
  let(:grouped_activities) { [] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      periodos: periods,
      current_periodo: first_period,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      activities_by_periods_renderer_service: activities_renderer
    )
  end

  it "builds percentage bottom rows and merges information rows without semester temporalidad" do
    expect(renderer.ficha_info_table_bottom_rows).to eq([])
    expect(renderer.grades_ficha_bottom_rows).to eq([
      [ "PERIODO 20%", "01/01/2024", "30/06/2024" ],
      [ "PERIODO 40%", "01/07/2024", "31/12/2024" ]
    ])
    expect(renderer.get_info_table_merged_rows_count).to eq(4)
    expect(renderer.get_grades_table_merged_rows_count).to eq(4)
    expect(renderer.get_kind_specific_table_header_colspan).to eq(5)
    expect(renderer.get_semestre).to eq("20%")
    expect(renderer.get_subtotal_max_grade).to eq("2")
  end

  it "appends later percentage headings and scores based on later-period activities" do
    allow(second_period).to receive(:activities).and_return([ :activity ])
    rows = [ [ "Axis" ], [ "Header", "20%" ], [ "Permanent", "0" ], [ "Temporal", "2" ], [ "Subtotal", "2" ] ]

    renderer.concat_tipo_porcentual_rows!(rows)

    expect(rows[1]).to eq([ "Header", "20%", "40%" ])
    expect(rows[2].last).to eq("2")
    expect(rows[3].last).to eq("2")
    expect(rows[4].last).to eq("2")
  end

  it "renders an empty temporal notice when there are no activities" do
    allow(docx).to receive(:p)
    allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
    expect(renderer).to receive(:li).with("Texto traducido")

    renderer.info_actividades_temporales_list
  end

  it "renders certificates for grouped activities" do
    allow(activities_renderer).to receive(:grouped_activities).and_return(
      [ double(activities: [ activity_renderer ]) ]
    )
    allow(docx).to receive(:p)
    allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
    expect(renderer).to receive(:li).with("Certificado.")

    renderer.info_actividades_temporales_list
  end
end
