class LegacyImportFile < ApplicationRecord
  belongs_to :parseable, polymorphic: true, optional: true
  has_one_attached :file

  after_save :check_if_duplicate!

  enum :status, {
    uploaded: 0,
    imported: 1,
    errored: 2,
    duplicate: 3,
    ignored: 4,
    file_removed: 5
  }

  # scope :sorted_by_last_modified, -> {
  #   order(
  #     last_modified_at: :desc,
  #     filename: :desc
  #   )
  # }
  scope :sorted_by_date, -> {
    order(
      year: :desc,
      month: :desc,
      last_modified_at: :desc,
      filename: :desc
    )
  }

  def last_modified_at_time
    Time.zone.at(last_modified_at.to_i / 1000)
  end

  def parseable_id_and_type
    [parseable_id, parseable_type].join("_")
  end

  private

  def check_if_duplicate!
    return unless status == "uploaded"

    existing_legacy_import_file = self.class.where(
      filename: filename,
      last_modified_at: last_modified_at,
      weight: weight
    ).where.not(id: self.id).first
    if existing_legacy_import_file.present?
      update!(
        status: :duplicate,
        duplicate_of_id: existing_legacy_import_file.id
      )
    end
  end
end
