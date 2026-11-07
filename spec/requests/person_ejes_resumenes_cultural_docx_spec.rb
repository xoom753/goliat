require "rails_helper"

RSpec.describe "Cultural report DOCX", type: :request do
  let(:report_attributes) do
    {
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: Date.new(2020, 1, 2),
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%\n40%",
      periodos_detalle: "02/01/20\t30/06/20\t180\t20%\n01/07/20\t31/12/20\t184\t40%",
      tipo_porcentual: true
    }
  end

  def expect_cultural_docx_download(report)
    get cultural_person_ejes_resumen_path(report, format: :docx)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to include("attachment", "Cultural-Casey Example.docx")
    expect(response.body).to start_with("PK")
  end

  describe "percentage-based template branch" do
    let(:percentage_report_attributes) do
      report_attributes.merge(
        tipo_porcentual: true,
        periodos_detalle: "02/01/20\t30/06/20\t180\t20%\n01/07/20\t31/12/20\t184\t40%"
      )
    end

    it "uses the first configured period for the draft and the report pages, without iterating semester groups" do
      report = PersonEjesResumen.create!(percentage_report_attributes)
      first_period = { start_date: "02/01/20", end_date: "30/06/20" }
      expect_any_instance_of(PersonEjeResumenRenderService)
        .not_to receive(:semestres_detail_hash)
      expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
        .to receive(:period=).with(first_period).twice.and_call_original

      expect_cultural_docx_download(report)
    end
  end

  describe "semester-based template branch" do
    let(:semester_report_attributes) do
      report_attributes.merge(
        tipo_porcentual: false,
        periodos_detalle: "02/01/20\t30/06/20\t180\t20%\n\n01/07/20\t31/12/20\t184\t40%"
      )
    end

    it "iterates both semester groups in the draft and report sections" do
      report = PersonEjesResumen.create!(semester_report_attributes)
      first_period = {
        start_date: "02/01/2020",
        end_date: "30/06/2020",
        percentage: "20%",
        semestre_str: "Primer semestre 0,00% al 20%"
      }
      second_period = {
        start_date: "01/07/2020",
        end_date: "31/12/2020",
        percentage: "40%",
        semestre_str: "Primer semestre 20,01% al 40%"
      }
      expect_any_instance_of(PersonEjeResumenRenderService)
        .to receive(:semestres_detail_hash).twice.and_call_original
      expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
        .to receive(:period=).with(first_period).twice.and_call_original
      expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
        .to receive(:period=).with(second_period).twice.and_call_original

      expect_cultural_docx_download(report)
    end
  end

  describe "with more periods" do
    let(:semester_report_attributes) do
      report_attributes.merge(
        tipo_porcentual: false,
        periodos_detalle: "02/01/20\t30/06/20\t180\t10%\n01/07/20\t31/12/20\t184\t20%\n\n01/01/21\t30/06/21\t180\t30%\n01/07/21\t31/12/21\t184\t40%"
      )
    end

    it "iterates both semester groups in the draft and report sections" do
      report = PersonEjesResumen.create!(semester_report_attributes)
      first_period = {
        start_date: "02/01/2020",
        end_date: "30/06/2020",
        percentage: "10%",
        semestre_str: "Primer semestre 0,00% al 10%"
      }
      second_period = {
        start_date: "01/07/2020",
        end_date: "31/12/2020",
        percentage: "20%",
        semestre_str: "Segundo semestre 10,01% al 20%"
      }
      third_period = {
        start_date: "01/01/2021",
        end_date: "30/06/2021",
        percentage: "30%",
        semestre_str: "Primer semestre 20,01% al 30%"
      }
      fourth_period = {
        start_date: "01/07/2021",
        end_date: "31/12/2021",
        percentage: "40%",
        semestre_str: "Segundo semestre 30,01% al 40%"
      }
      expect_any_instance_of(PersonEjeResumenRenderService)
        .to receive(:semestres_detail_hash).twice.and_call_original
      2.times do
        expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
          .to receive(:period=).with(first_period).and_call_original
        expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
          .to receive(:period=).with(second_period).and_call_original
        expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
          .to receive(:period=).with(third_period).and_call_original
        expect_any_instance_of(InformeRendererService::InformeCulturalRenderer)
          .to receive(:period=).with(fourth_period).and_call_original
      end

      expect_cultural_docx_download(report)
    end
  end
end
