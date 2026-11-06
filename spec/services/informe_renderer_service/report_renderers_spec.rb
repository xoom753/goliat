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
        renderer.semestre = "20%"
        allow(renderer).to receive(:get_activities_within_period).and_return([:activity])
        expect(docx).to receive(:table) do |rows, &block|
          if renderer_class == InformeRendererService::InformeLaboralRenderer
            # get rid of the title
            title_row = rows.shift
            expect( title_row ).to include(expected_axis)
          else
            expect(rows[1]).to include(expected_axis)
          end

          expect(rows[0]).to include("20%")
          expect(rows[1]).to include("PERMANENTE", "3", "0")
          expect(rows[2]).to include("TEMPORAL", "2", "2")
          expect(rows.last).to include("Subtotal", "5", "2")
        end

        renderer.ficha_qualy_main_table
      end

      it "gives zero temporal points when no activities qualify" do
        renderer.semestre = "20%"
        allow(renderer).to receive(:get_activities_within_period).and_return([])
        expect(docx).to receive(:table) do |rows, &block|
          expect(rows.last).to include("Subtotal", "5", "0")
        end

        renderer.ficha_qualy_main_table
      end

      describe "#qualy_table_rows" do
        it "includes temporal scores and the second percentage column for percentage reports" do
          renderer.semestre = "20%"
          allow(renderer).to receive(:get_activities_within_period).and_return([:qualifying_activity])
          allow(report).to receive(:tipo_porcentual?).and_return(true)
          allow(report).to receive(:periodos_porcentuales).and_return(
            "20%" => [{ start_date: "01/01/2024", end_date: "30/06/2024" }],
            "40%" => [{ start_date: "01/07/2024", end_date: "31/12/2024" }]
          )

          rows = renderer.send(:qualy_table_rows)

          if renderer_class == InformeRendererService::InformeLaboralRenderer
            # get rid of the title
            rows.shift
            expect( rows.first[4,2] ).to include("20%", "40%")
          else
            expect( rows.first[2,2] ).to include("20%", "40%")
          end
          expect( rows[1][3,3] ).to include("3", "0", "0")
          expect( rows[2][3,3] ).to include("2", "2", "0")
          expect( rows[3][1,3] ).to include("5", "2", "0")
        end

        it "includes the configured semester and temporal score for semester reports" do
          renderer.semestre = "20%"
          allow(renderer).to receive(:get_activities_within_period).and_return([])
          allow(report).to receive(:tipo_porcentual?).and_return(false)

          rows = renderer.send(:qualy_table_rows)

          if renderer_class == InformeRendererService::InformeLaboralRenderer
            # get rid of the title
            rows.shift
          end

          expect(rows.first.last).to eq("20%")
          expect(
            rows[1].last
          ).to include("0")
          expect(
            rows[2].last
          ).to include("0")
          expect(
            rows[3].last
          ).to eq("0")
        end
      end

      if renderer_class == InformeRendererService::InformeLaboralRenderer
        describe "#get_header_colspan" do
          it "uses five columns for semester reports" do
            allow(report).to receive(:tipo_porcentual?).and_return(false)

            expect(renderer.send(:get_header_colspan)).to eq(5)
          end

          it "adds one column for each percentage after the first" do
            allow(report).to receive(:tipo_porcentual?).and_return(true)
            allow(report).to receive(:periodos_porcentuales).and_return(
              "20%" => [], "40%" => [], "60%" => []
            )

            expect(renderer.send(:get_header_colspan)).to eq(7)
          end
        end
      end
    end
  end
end
