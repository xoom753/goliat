class AddPrimerSemestrePercentageToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :primer_semestre_porcentaje, :string
  end
end
