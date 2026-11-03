class AddTipoPorcentualToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :tipo_porcentual, :boolean
  end
end
