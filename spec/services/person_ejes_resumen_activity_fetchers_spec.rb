require "rails_helper"

RSpec.describe PersonEjesResumen::LegacyActivitiesFetcherService do
  describe "#activities" do
    it "fetches legacy activities for selected legacy people in the requested eje group" do
      cultural_group = ActivityGroup.create!(nombre: "Eje Cultural")
      labor_group = ActivityGroup.create!(nombre: "Eje Laboral")
      cultural_legacy_group = LegacyActivityGroup.create!(nombre: "Workshops", activity_group: cultural_group)
      labor_legacy_group = LegacyActivityGroup.create!(nombre: "Jobs", activity_group: labor_group)
      selected_person = LegacyPerson.create!(nombres: "Jane Example")
      other_person = LegacyPerson.create!(nombres: "Alex Rivera")
      selected_activity = LegacyActivity.create!(nombre: "Weaving")
      other_activity = LegacyActivity.create!(nombre: "Cleaning")

      expected = LegacyPersonActivity.create!(
        legacy_person: selected_person,
        legacy_activity_group: cultural_legacy_group,
        legacy_activity: selected_activity,
        end_date: Date.new(2024, 3, 31)
      )
      LegacyPersonActivity.create!(
        legacy_person: other_person,
        legacy_activity_group: cultural_legacy_group,
        legacy_activity: selected_activity,
        end_date: Date.new(2024, 3, 31)
      )
      LegacyPersonActivity.create!(
        legacy_person: selected_person,
        legacy_activity_group: labor_legacy_group,
        legacy_activity: other_activity,
        end_date: Date.new(2024, 3, 31)
      )

      summary = PersonEjesResumen.new(legacy_people_ids: selected_person.id.to_s)
      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(expected)
    end

    it "raises when the requested eje activity group does not exist" do
      summary = PersonEjesResumen.new(legacy_people_ids: "1")

      expect do
        described_class.new(kind: :cultural, person_ejes_resumen: summary).activities
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe "when person_ejes_resumen has no legacy_people_ids" do
      it "returns an empty relation without requiring an eje group" do
        summary = PersonEjesResumen.new(legacy_people_ids: nil)

        expect(ActivityGroup).not_to receive(:find_by!)
        expect(described_class.new(kind: :cultural, person_ejes_resumen: summary).activities).to eq([])
      end
    end

    it "includes activities for each selected legacy person" do
      cultural_group = ActivityGroup.create!(nombre: "Eje Cultural")
      legacy_group = LegacyActivityGroup.create!(nombre: "Workshops", activity_group: cultural_group)
      first_person = LegacyPerson.create!(nombres: "Jane Example")
      second_person = LegacyPerson.create!(nombres: "Alex Rivera")
      first_activity = LegacyPersonActivity.create!(legacy_person: first_person, legacy_activity_group: legacy_group)
      second_activity = LegacyPersonActivity.create!(legacy_person: second_person, legacy_activity_group: legacy_group)
      summary = PersonEjesResumen.new(legacy_people_ids: "#{first_person.id},#{second_person.id}")

      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(first_activity, second_activity)
    end
  end
end

RSpec.describe PersonEjesResumen::PresentActivitiesFetcherService do
  describe "#activities" do
    it "fetches present activities for selected people and the requested eje group" do
      cultural_group = ActivityGroup.create!(nombre: "Eje Cultural")
      sports_group = ActivityGroup.create!(nombre: "Eje Deportivo")
      selected_person = Person.create!(nombres: "Jane Example", dni: "111")
      other_person = Person.create!(nombres: "Alex Rivera", dni: "222")
      cultural_activity = Activity.create!(nombre: "Painting", activity_group: cultural_group)
      unrelated_activity = Activity.create!(nombre: "Football", activity_group: sports_group)

      expected = PersonActivity.create!(
        person: selected_person,
        coursable: cultural_activity,
        anio: 2024,
        mes: 3
      )
      PersonActivity.create!(
        person: other_person,
        coursable: cultural_activity,
        anio: 2024,
        mes: 3
      )
      PersonActivity.create!(
        person: selected_person,
        coursable: unrelated_activity,
        anio: 2024,
        mes: 3
      )

      summary = PersonEjesResumen.new(people_ids: selected_person.id.to_s)
      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(expected)
    end

    it "raises when the requested eje activity group does not exist" do
      summary = PersonEjesResumen.new(people_ids: "1")

      expect do
        described_class.new(kind: :cultural, person_ejes_resumen: summary).activities
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe "when person_ejes_resumen has no people_ids" do
      it "returns an empty relation without requiring an eje group" do
        summary = PersonEjesResumen.new(people_ids: "")

        expect(ActivityGroup).not_to receive(:find_by!)
        expect(described_class.new(kind: :cultural, person_ejes_resumen: summary).activities).to eq([])
      end
    end

    it "includes activities for each selected person" do
      cultural_group = ActivityGroup.create!(nombre: "Eje Cultural")
      activity = Activity.create!(nombre: "Painting", activity_group: cultural_group)
      first_person = Person.create!(nombres: "Jane Example", dni: "111")
      second_person = Person.create!(nombres: "Alex Rivera", dni: "222")
      first_activity = PersonActivity.create!(person: first_person, coursable: activity, anio: 2024, mes: 3)
      second_activity = PersonActivity.create!(person: second_person, coursable: activity, anio: 2024, mes: 4)
      summary = PersonEjesResumen.new(people_ids: "#{first_person.id},#{second_person.id}")

      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(first_activity, second_activity)
    end
  end
end
