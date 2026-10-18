class LegacyImportFile < ApplicationRecord
  belongs_to :parseable, polymorphic: true, optional: true
  has_one_attached :file

  enum :status, {
    uploaded: 0,
    imported: 1,
    errored: 2,
    duplicate: 3
  }

  def last_modified_at_time
    Time.zone.at(last_modified_at.to_i / 1000)
  end

  def parseable_id_and_type
    [parseable_id, parseable_type].join("_")
  end
end
