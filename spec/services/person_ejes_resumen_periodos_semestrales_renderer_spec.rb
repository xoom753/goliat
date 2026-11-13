require "rails_helper"

RSpec.describe PersonEjesResumen::ByTipoPeriodoRendererService::PeriodosSemestralesRenderer do
  let(:docx) { double }
  let(:period) do
    double(
      period_percentage: "20%",
      semestre_str: "Primer semestre 0,00% al 20%",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 6, 30),
      activities: activities
    )
  end
  let(:summary) do
    double(
      several_delitos?: false,
      fecha_traslado: nil,
      delitos_array: [ "Robo" ]
    )
  end
  let(:translator) { double(t: "Texto traducido") }
  let(:activity_renderer) { double(render_string: "Certificado") }
  let(:activities_renderer) { double }
  let(:activities) { [] }
  subject(:renderer) do
    described_class.new(
      docx: docx,
      periodos: [ period ],
      current_periodo: period,
      person_ejes_resumen: summary,
      informes_translator_service: translator,
      activities_by_periods_renderer_service: activities_renderer
    )
  end

  it "returns semester-specific bottom rows and grades-table metadata" do
    expect(renderer.ficha_info_table_bottom_rows).to eq([
      [ "TEMPORALIDAD", "20%" ],
      [ "SEMESTRE", "01/01/2024", "30/06/2024" ]
    ])
    expect(renderer.grades_ficha_bottom_rows).to eq([
      [ "PRIMER SEMESTRE 0,00% AL 20%", "01/01/2024", "30/06/2024" ]
    ])
    expect(renderer.get_semestre).to eq("20%")
    expect(renderer.get_kind_specific_table_header_colspan).to eq(4)
    expect(renderer.get_subtotal_max_grade).to eq("5")
  end

  it "renders the permanent and temporal empty activity notices" do
    allow(docx).to receive(:p)
    allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
    expect(renderer).to receive(:li).with("Texto traducido").twice

    renderer.info_actividades_permanentes_list
    renderer.info_actividades_temporales_list
  end

  it "renders temporal activity certificates when the current period has activities" do
    allow(period).to receive(:activities).and_return([ activity_renderer ])
    allow(docx).to receive(:p)
    allow(docx).to receive(:ol) { |&block| renderer.instance_exec(&block) }
    expect(renderer).to receive(:li).with("Certificado.")

    renderer.info_actividades_temporales_list
  end
end
