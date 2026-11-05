require "rails_helper"

RSpec.describe ExtraActivity, type: :model do
  it "destroys associated person activities when destroyed" do
    person = Person.create!(nombres: "Casey Example")
    activity = described_class.create!(nombre: "Workshop")
    person_activity = PersonActivity.create!(
      person: person,
      coursable: activity,
      anio: 2025,
      mes: 3
    )

    expect { activity.destroy }.to change(PersonActivity, :count).by(-1)
    expect(PersonActivity.exists?(person_activity.id)).to be(false)
  end
end
