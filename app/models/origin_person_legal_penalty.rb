class OriginPersonLegalPenalty < ApplicationRecord
  EN_PROCESO = "EN PROCESO".freeze

  belongs_to :origin_person
  belongs_to :origin_person_legal_process

  attr_accessor :termina_condena_at_str,
                :veinte_porciento_at_str,
                :cuarenta_porciento_at_str,
                :sesenta_porciento_at_str,
                :ochenta_porciento_at_str,
                :cantidad_total_sentencia_str

  before_save :set_accessors_if_present!

  private

  def set_accessors_if_present!
    self.cantidad_total_sentencia = cantidad_total_sentencia_str if cantidad_total_sentencia_str != EN_PROCESO
    self.termina_condena_at = termina_condena_at_str if termina_condena_at_str != EN_PROCESO
    self.veinte_porciento_at = veinte_porciento_at_str if veinte_porciento_at_str != EN_PROCESO
    self.cuarenta_porciento_at = cuarenta_porciento_at_str if cuarenta_porciento_at_str != EN_PROCESO
    self.sesenta_porciento_at = sesenta_porciento_at_str if sesenta_porciento_at_str != EN_PROCESO
    self.ochenta_porciento_at = ochenta_porciento_at_str if ochenta_porciento_at_str != EN_PROCESO
  end
end
