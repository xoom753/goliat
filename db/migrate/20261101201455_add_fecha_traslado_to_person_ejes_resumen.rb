class AddFechaTrasladoToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :fecha_traslado, :date
    add_column :person_ejes_resumenes, :ubicacion_traslado, :string
  end
end
