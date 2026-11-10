require "rails_helper"

RSpec.describe "Cultural report DOCX", type: :request do
  let!(:activity_group) {
    ActivityGroup.create!(
      nombre: "Eje Cultural"
    )
  }
  let(:report) do
    PersonEjesResumen.create!(
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: periods_detail,
      tipo_porcentual: percentage_mode
    )
  end
  let(:percentage_mode) { true }

  describe "porcentual" do
    let(:periods_detail) { "02/01/20\t30/06/20\t180\t20%\n01/07/20\t31/12/20\t184\t40%" }

    it "renders a named DOCX and builds one ficha index for percentage mode" do
      expect_any_instance_of(PersonEjesResumen::InformeRendererService)
        .to receive(:get_fichas_indexes).and_wrap_original do |method|
          indexes = method.call
          expect(indexes).to eq([0])
          indexes
        end

      get cultural_person_ejes_resumen_path(report, format: :docx)

      expect(response).to have_http_status(:ok)
      expect(response.headers["Content-Disposition"]).to include("attachment", "Cultural-Casey Example.docx")
      expect(response.body).to start_with("PK")
    end
  end

  describe "semestral" do
    let(:periods_detail) { "02/01/20\t30/06/20\t180\t20%\n\n01/07/20\t31/12/20\t184\t40%" }

    it "builds a ficha index for each semester period" do
      report.update!(tipo_porcentual: false)
      expect_any_instance_of(PersonEjesResumen::InformeRendererService)
        .to receive(:get_fichas_indexes).and_wrap_original do |method|
          indexes = method.call
          expect(indexes.to_a).to eq([0, 1])
          indexes
        end

      get cultural_person_ejes_resumen_path(report, format: :docx)

      expect(response).to have_http_status(:ok)
      expect(response.headers["Content-Disposition"]).to include("Cultural-Casey Example.docx")
      expect(response.body).to start_with("PK")
    end
  end
end
