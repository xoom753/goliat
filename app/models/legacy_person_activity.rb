class LegacyPersonActivity < ApplicationRecord
    attr_accessor :nombres_str,
                  :activity_str,
                  :activity_group_str,
                  :activity_detail_str


    belongs_to :legacy_person, optional: true
    belongs_to :legacy_activity, optional: true
    belongs_to :legacy_activity_group, optional: true
    belongs_to :legacy_activity_detail, optional: true

    before_save :reference_legacy_person!
    before_save :reference_legacy_activity!
    before_save :reference_legacy_activity_group!
    before_save :reference_legacy_activity_detail!

    scope :sorted_by_date, -> { order(end_date: :desc) }
    scope :oldest_first, -> { order(end_date: :asc) }

    ##
    # "02/06/2022" => 02/06/2022
    def self.parse_date_str(date)
        Date.strptime(date, "%d/%m/%Y")
    end

    private

    def reference_legacy_person!
        return if nombres_str.blank?
        self.legacy_person = LegacyPerson.where(
            nombres: nombres_str
        ).first_or_create!
    end

    def reference_legacy_activity!
        return if activity_str.blank?
        self.legacy_activity = LegacyActivity.where(
            nombre: activity_str
        ).first_or_create!
    end

    def reference_legacy_activity_group!
        return if activity_group_str.blank?
        self.legacy_activity_group = LegacyActivityGroup.where(
            nombre: activity_group_str
        ).first_or_create!
    end

    def reference_legacy_activity_detail!
        return if activity_detail_str.blank?
        self.legacy_activity_detail = LegacyActivityDetail.where(
            nombre: activity_detail_str
        ).first_or_create!
    end
end
