require "rails_helper"

RSpec.describe "Import legacy people activities", type: :request do
  describe "GET /import_legacy_people_activities/new" do
    it "renders the import form with ordered activities and groups" do
      LegacyActivity.create!(nombre: "Zulu")
      LegacyActivity.create!(nombre: "Alpha")
      LegacyActivityGroup.create!(nombre: "Second")
      LegacyActivityGroup.create!(nombre: "First")

      get new_import_legacy_people_activity_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Importar actividades (archivo)")
      expect(response.body.index("Alpha")).to be < response.body.index("Zulu")
      expect(response.body.index("First")).to be < response.body.index("Second")
    end
  end

  describe "POST /import_legacy_people_activities" do
    let(:activity) { LegacyActivity.create!(nombre: "Workshop") }
    let(:activity_detail) { LegacyActivityDetail.create!(nombre: "Course attendance") }
    let(:activity_group) { LegacyActivityGroup.create!(nombre: "Education") }
    let(:import_attributes) do
      {
        legacy_activity_id: activity.id,
        legacy_activity_group_id: activity_group.id,
        duracion: "12 horas",
        start_date: "2024-01-01",
        end_date: "2024-01-31",
        activity_dates: "01/01/2024-31/01/2024",
        activity_detail_str: "Course attendance",
        people: "  jane DOE smith  \n\n  alex RIVERA  "
      }
    end

    it "creates an activity for each nonblank name, preserving input row numbers" do
      activity
      activity_detail
      activity_group

      expect do
        post import_legacy_people_activities_path,
             params: { legacy_person_activities: import_attributes }
      end.to change(LegacyPersonActivity, :count).by(2)

      expect(response).to redirect_to(new_import_legacy_people_activity_path(
        legacy_activity_id: activity.id,
        legacy_activity_group_id: activity_group.id,
        duracion: "12 horas",
        end_date: "2024-01-31",
        start_date: "2024-01-01",
        activity_dates: "01/01/2024-31/01/2024",
        activity_detail_str: "Course attendance"
      ))
      expect(flash[:notice]).to eq("2 imported")
      expect(LegacyPersonActivity.order(:row_number).map(&:row_number)).to eq([1, 3])
      expect(LegacyPersonActivity.order(:row_number).map { |record| record.legacy_person.nombres }).to eq(["Jane Doe Smith", "Alex Rivera"])
      expect(LegacyPersonActivity.first).to have_attributes(
        duracion: "12 horas",
        start_date: Date.new(2024, 1, 1),
        end_date: Date.new(2024, 1, 31),
        activity_dates: "01/01/2024-31/01/2024",
        legacy_activity_detail_id: activity_detail.id,
        legacy_activity_id: activity.id,
        legacy_activity_group_id: activity_group.id
      )
    end

    it "redirects and reports zero when the submitted names are blank" do
      expect do
        post import_legacy_people_activities_path,
             params: {
               legacy_person_activities: import_attributes.merge(people: " \n\n ")
             }
      end.not_to change(LegacyPersonActivity, :count)

      expect(response).to redirect_to(new_import_legacy_people_activity_path(
        legacy_activity_id: activity.id,
        legacy_activity_group_id: activity_group.id,
        duracion: "12 horas",
        end_date: "2024-01-31",
        start_date: "2024-01-01",
        activity_dates: "01/01/2024-31/01/2024",
        activity_detail_str: "Course attendance"
      ))
      expect(flash[:notice]).to eq("0 imported")
    end
  end
end
