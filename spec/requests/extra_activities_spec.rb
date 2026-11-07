require "rails_helper"
require "csv"

RSpec.describe "Extra activities", type: :request do
  def create_extra_activity(name)
    extra_activity = ExtraActivity.create!(nombre: name)
    group = ActivityGroup.create!(nombre: "Test group")
    Activity.create!(id: extra_activity.id, nombre: "Foreign key target", activity_group: group)
    extra_activity
  end

  describe "GET /extra_activities" do
    it "lists extra activities" do
      activity = ExtraActivity.create!(nombre: "Workshop")

      get extra_activities_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Workshop")
      expect(response.body).to include(edit_extra_activity_path(activity))
    end
  end

  describe "GET /extra_activities/new" do
    it "creates a new extra activity and redirects to its edit page" do
      ExtraActivity.create!(nombre: "Existing")

      expect do
        get new_extra_activity_path
      end.to change(ExtraActivity, :count).by(1)

      activity = ExtraActivity.order(:id).last
      expect(activity.nombre).to eq("Nueva Actividad extra 2")
      expect(response).to redirect_to(edit_extra_activity_path(activity))
    end
  end

  describe "GET /extra_activities/:id/edit" do
    it "renders the activity and its participants" do
      activity = create_extra_activity("Workshop")
      person = Person.create!(nombres: "Jane Example", dni: "123", pabellon: "A-1")
      PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024)

      get edit_extra_activity_path(activity)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Workshop", "Jane Example", "123", "A-1")
    end
  end

  describe "PUT /extra_activities/:id" do
    it "adds the selected person as a participant for the current month" do
      activity = create_extra_activity("Workshop")
      person = Person.create!(nombres: "Jane Example", dni: "123")

      expect do
        put extra_activity_path(activity), params: {
          person_id: person.id,
          month: "2",
          year: "2020"
        }
      end.to change(PersonActivity, :count).by(1)

      participant = PersonActivity.last
      expect(participant).to have_attributes(
        person_id: person.id,
        coursable: activity,
        mes: Date.today.month,
        anio: Date.today.year
      )
      expect(response).to redirect_to(edit_extra_activity_path(activity, month: "2", year: "2020"))
    end
  end

  describe "PUT /extra_activities/:id/update_name" do
    it "updates the activity name and redirects to edit" do
      activity = ExtraActivity.create!(nombre: "Old name")

      put update_name_extra_activity_path(activity), params: { nombre: "New name" }

      expect(activity.reload.nombre).to eq("New name")
      expect(response).to redirect_to(edit_extra_activity_path(activity))
    end
  end

  describe "DELETE /extra_activities/:id" do
    it "removes the selected participant and redirects to edit" do
      activity = create_extra_activity("Workshop")
      person = Person.create!(nombres: "Jane Example", dni: "123")
      participant = PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024)

      expect do
        delete extra_activity_path(activity), params: { person_activity_id: participant.id }
      end.to change(PersonActivity, :count).by(-1)

      expect(response).to redirect_to(edit_extra_activity_path(activity))
    end
  end

  describe "GET /extra_activities/:id/export" do
    it "sends participant data as a dated CSV attachment" do
      activity = create_extra_activity("Workshop")
      person = Person.create!(nombres: "Jane Example", dni: "123", pabellon: "A-1")
      PersonActivity.create!(person: person, coursable: activity, mes: 3, anio: 2024)

      get export_extra_activity_path(activity)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include(
        "attachment",
        "Workshop-#{Date.today}.csv"
      )
      csv = CSV.parse(response.body, headers: true)
      expect(csv.headers.first(5)).to eq([
        "Nombres", "Cédula", "Pabellón", "Workshop", activity.created_at.to_date.to_s
      ])
      expect(csv.headers.length).to eq(6)
      expect(csv.headers.last).to be_present
      expect(csv.first.fields.first(3)).to eq(["Jane Example", "123", "A-1"])
    end
  end
end
