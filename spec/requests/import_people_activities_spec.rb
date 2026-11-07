require "rails_helper"
require "json"

RSpec.describe "Import people activities", type: :request do
  describe "POST /import_people_activities" do
    let(:person) { Person.create!(nombres: "Jane Doe", dni: "111") }
    let(:activity_group) { ActivityGroup.create!(nombre: "Cultural") }
    let(:activity) { Activity.create!(nombre: "Tejido", activity_group: activity_group) }
    let(:date) { { month: "3", year: "2024" } }

    it "imports matching people and maps cargo labels to enums" do
      person
      activity
      rows = [
        "Jane Doe\t111\tInstructor",
        "Jane Doe\t111\tApoyo",
        "Jane Doe\t111\tIndependiente",
        "Jane Doe\t111\tResponsable",
        "Jane Doe\t111\tCP"
      ].join("\n")

      expect do
        post import_people_activities_path,
             params: { activity_id: activity.id, date: date, people_activities: rows }
      end.to change(PersonActivity, :count).by(5)

      expect(response).to redirect_to(action: :new)
      expect(flash[:notice]).to eq("5 imported!")
      expect(PersonActivity.order(:id).map(&:cargo)).to eq([
        "instructor", "apoyo", "independiente", "responsable", "cuentapropia"
      ])
      expect(PersonActivity.pluck(:mes, :anio).uniq).to eq([[3, 2024]])
      expect(PersonActivity.pluck(:coursable_type, :coursable_id).uniq).to eq([["Activity", activity.id]])
    end

    it "records an import error for an unknown DNI and reports the input row count" do
      activity

      expect do
        post import_people_activities_path,
             params: {
               activity_id: activity.id,
               date: date,
               people_activities: "Unknown Person\t999\tInstructor"
             }
      end.to change(ImportError, :count).by(1)

      expect(response).to redirect_to(action: :new)
      expect(flash[:notice]).to eq("1 imported!")
      details = ImportError.last.details_object
      expect(details).to include(
        nombres: "Unknown Person",
        dni: "999",
        cargo: "Instructor",
        mes: "3",
        anio: "2024",
        activity: "Tejido"
      )
    end

    it "uses the default cargo when no recognized cargo is supplied" do
      person
      activity

      post import_people_activities_path,
           params: {
             activity_id: activity.id,
             date: date,
             people_activities: "Jane Doe\t111\tEstudiante"
           }

      expect(PersonActivity.last.cargo).to eq("estudiante")
    end
  end
end
