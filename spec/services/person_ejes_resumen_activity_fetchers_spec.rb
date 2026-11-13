require "rails_helper"

RSpec.describe PersonEjesResumen::ActivitiesFetcherService::LegacyActivitiesFetcher do
  describe "#activities" do
    it "filters legacy activities by selected people and treatment group" do
      cultural = ActivityGroup.create!(nombre: "Eje Cultural")
      laboral = ActivityGroup.create!(nombre: "Eje Laboral")
      cultural_legacy_group = LegacyActivityGroup.create!(nombre: "Workshops", activity_group: cultural)
      laboral_legacy_group = LegacyActivityGroup.create!(nombre: "Jobs", activity_group: laboral)
      selected = LegacyPerson.create!(nombres: "Jane Example")
      other = LegacyPerson.create!(nombres: "Alex Rivera")
      activity = LegacyActivity.create!(nombre: "Weaving")
      expected = LegacyPersonActivity.create!(legacy_person: selected, legacy_activity: activity, legacy_activity_group: cultural_legacy_group)
      LegacyPersonActivity.create!(legacy_person: other, legacy_activity: activity, legacy_activity_group: cultural_legacy_group)
      LegacyPersonActivity.create!(legacy_person: selected, legacy_activity: activity, legacy_activity_group: laboral_legacy_group)
      summary = PersonEjesResumen.new(legacy_people_ids: [ selected.id ])

      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(expected)
    end

    it "includes records belonging to all selected legacy people" do
      group = ActivityGroup.create!(nombre: "Eje Cultural")
      legacy_group = LegacyActivityGroup.create!(nombre: "Workshops", activity_group: group)
      activity = LegacyActivity.create!(nombre: "Weaving")
      people = [ LegacyPerson.create!(nombres: "Jane"), LegacyPerson.create!(nombres: "Alex") ]
      records = people.map do |person|
        LegacyPersonActivity.create!(legacy_person: person, legacy_activity: activity, legacy_activity_group: legacy_group)
      end
      summary = PersonEjesResumen.new(legacy_people_ids: people.map(&:id))

      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(*records)
    end

    it "returns an empty array without resolving a group when there are no selected IDs" do
      summary = PersonEjesResumen.new(legacy_people_ids: [])
      expect(ActivityGroup).not_to receive(:find_by!)

      expect(described_class.new(kind: :cultural, person_ejes_resumen: summary).activities).to eq([])
    end

    it "raises when the requested treatment group is missing and IDs are present" do
      summary = PersonEjesResumen.new(legacy_people_ids: [ 1 ])

      expect { described_class.new(kind: :cultural, person_ejes_resumen: summary).activities }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

RSpec.describe PersonEjesResumen::ActivitiesFetcherService::PresentActivitiesFetcher do
  describe "#activities" do
    it "filters present activities by selected people and treatment group" do
      cultural = ActivityGroup.create!(nombre: "Eje Cultural")
      sports = ActivityGroup.create!(nombre: "Eje Deportivo")
      selected = Person.create!(nombres: "Jane Example", dni: "111")
      other = Person.create!(nombres: "Alex Rivera", dni: "222")
      painting = Activity.create!(nombre: "Painting", activity_group: cultural)
      football = Activity.create!(nombre: "Football", activity_group: sports)
      expected = PersonActivity.create!(person: selected, coursable: painting, anio: 2024, mes: 3)
      PersonActivity.create!(person: other, coursable: painting, anio: 2024, mes: 3)
      PersonActivity.create!(person: selected, coursable: football, anio: 2024, mes: 3)
      summary = PersonEjesResumen.new(people_ids: [ selected.id ])

      result = described_class.new(kind: :cultural, person_ejes_resumen: summary).activities

      expect(result).to contain_exactly(expected)
    end

    it "includes records for all selected current people" do
      group = ActivityGroup.create!(nombre: "Eje Cultural")
      activity = Activity.create!(nombre: "Painting", activity_group: group)
      people = [ Person.create!(nombres: "Jane", dni: "1"), Person.create!(nombres: "Alex", dni: "2") ]
      records = people.map { |person| PersonActivity.create!(person: person, coursable: activity, anio: 2024, mes: 3) }
      summary = PersonEjesResumen.new(people_ids: people.map(&:id))

      expect(described_class.new(kind: :cultural, person_ejes_resumen: summary).activities).to contain_exactly(*records)
    end

    it "returns an empty array without resolving a group when there are no selected IDs" do
      summary = PersonEjesResumen.new(people_ids: [])
      expect(ActivityGroup).not_to receive(:find_by!)

      expect(described_class.new(kind: :cultural, person_ejes_resumen: summary).activities).to eq([])
    end

    it "raises when the requested treatment group is missing and IDs are present" do
      summary = PersonEjesResumen.new(people_ids: [ 1 ])

      expect { described_class.new(kind: :cultural, person_ejes_resumen: summary).activities }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
