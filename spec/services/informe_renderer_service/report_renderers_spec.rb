require "rails_helper"

RSpec.describe "InformeRendererService report table renderers" do
  {
    InformeRendererService::InformeCulturalRenderer => "CULTURAL",
    InformeRendererService::InformeDeportivoRenderer => "DEPORTIVO",
    InformeRendererService::InformeLaboralRenderer => "LABORAL"
  }.each do |renderer_class, expected_axis|
    describe renderer_class.name do
      let(:docx) { double(h1: nil, p: nil) }
      let(:report) do
        double(
          docx: docx,
          kind: expected_axis.downcase.to_sym,
          person_ejes_renderer: double,
          legacy_person_activities_by_date: {},
          tipo_porcentual?: false,
          periodos_porcentuales: {},
          get_first_period: nil
        )
      end
      subject(:renderer) { renderer_class.new(report) }

      it "passes an evaluation table with a temporal score based on activity presence" do
        renderer.semestre = "5"
        allow(renderer).to receive(:get_activities_within_period).and_return([:activity])
        expect(docx).to receive(:table) do |rows, &block|
          expect(rows.flatten).to include("2", expected_axis)
          expect(rows.flatten).to include("Subtotal")
        end

        renderer.ficha_qualy_main_table
      end

      it "gives zero temporal points when no activities qualify" do
        renderer.semestre = "0"
        allow(renderer).to receive(:get_activities_within_period).and_return([])
        expect(docx).to receive(:table) do |rows, &block|
          expect(rows.flatten).to include("0")
        end

        renderer.ficha_qualy_main_table
      end

      describe "#table_rows" do
        describe "tipo_porcentual? true" do

        end

        describe "tipo_porcentual? false" do

        end
      end
    end
  end
end
