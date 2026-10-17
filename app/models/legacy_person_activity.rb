class LegacyPersonActivity < ApplicationRecord
    attr_accessor :nombres_str,
                  :activity_group_str,
                  :activity_str

    belongs_to :legacy_person, optional: true
    belongs_to :legacy_activity, optional: true
    belongs_to :legacy_activity_group, optional: true

    before_save :reference_legacy_person!
    before_save :reference_legacy_activity!
    before_save :reference_legacy_activity_group!

    private

    def reference_legacy_person!
        self.legacy_person = LegacyPerson.where(
            nombres: nombres_str
        ).first_or_create!
    end

    def reference_legacy_activity!
        self.legacy_activity = LegacyActivity.where(
            nombre: activity_str
        ).first_or_create!
    end

    def reference_legacy_activity_group!
        self.legacy_activity_group = LegacyActivityGroup.where(
            nombre: activity_group_str
        ).first_or_create!
    end
end
