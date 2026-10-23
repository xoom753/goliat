class CreateOriginPersonLegalPenalties < ActiveRecord::Migration[8.1]
  def change
    create_table :origin_person_legal_penalties do |t|
      t.integer :anios_acumulacion_pena
      t.integer :meses_acumulacion_pena
      t.integer :dias_acumulacion_pena
      t.integer :acumulacion_total_penas
      t.integer :anios_pena_individual
      t.integer :meses_pena_individual
      t.integer :dias_pena_individual
      t.integer :acumulacion_pena_individual_total
      t.integer :cantidad_total_sentencia
      t.date :termina_condena_at
      t.date :veinte_porciento_at
      t.date :cuarenta_porciento_at
      t.date :sesenta_porciento_at
      t.date :ochenta_porciento_at
      t.references :origin_person, null: false, foreign_key: true
      t.references :origin_person_legal_process, null: false, foreign_key: true

      t.timestamps
    end
  end
end
