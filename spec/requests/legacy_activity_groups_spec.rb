require "rails_helper"

RSpec.describe "Legacy activity groups", type: :request do
  it "lists groups alphabetically" do
    LegacyActivityGroup.create!(nombre: "Zulu")
    LegacyActivityGroup.create!(nombre: "Alpha")

    get legacy_activity_groups_path

    expect(response).to have_http_status(:ok)
    expect(response.body.index("Alpha")).to be < response.body.index("Zulu")
  end

  it "updates the treatment group association" do
    legacy_group = LegacyActivityGroup.create!(nombre: "Workshops")
    treatment_group = ActivityGroup.create!(nombre: "Cultural")

    put legacy_activity_group_path(legacy_group), params: {
      legacy_activity_group: { activity_group_id: treatment_group.id }
    }

    expect(legacy_group.reload.activity_group).to eq(treatment_group)
    expect(response).to redirect_to(action: :index)
  end
end
