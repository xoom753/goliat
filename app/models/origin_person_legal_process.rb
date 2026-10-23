class OriginPersonLegalProcess < ApplicationRecord
  belongs_to :origin_person
  has_one :origin_person_legal_penalty

  attr_accessor :estado_str

  before_save :set_estado!

  enum :estado, {
    en_proceso: 0,
    con_sentencia: 1
  }

  private

  def set_estado!
    return if estado_str.blank?
    self.estado = estado_str.downcase.sub(" ", "_")
  end
end
