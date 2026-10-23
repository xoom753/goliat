class CreateOriginPersonLegalProcesses < ActiveRecord::Migration[8.1]
  def change
    create_table :origin_person_legal_processes do |t|
      t.date :fecha_detencion
      t.date :fecha_delito
      t.date :fecha_ingreso
      t.integer :estado, default: 0
      t.integer :anios_sentencia
      t.integer :meses_sentencia
      t.integer :dias_sentencia
      t.date :fecha_sentencia
      t.string :boleta_encarcelamiento
      t.date :fecha_boleta_encarcelamiento
      t.string :proceso_num
      t.string :normativa
      t.string :infraccion
      t.string :incisos
      t.string :grupo_infraccion
      t.string :subgrupo_infraccion
      t.string :parte_policial_num
      t.text :observaciones
      t.text :observaciones_2
      t.references :origin_person, null: false, foreign_key: true

      t.timestamps
    end
    add_index :origin_person_legal_processes, :proceso_num
  end
end
