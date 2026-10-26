class AddUbicacionToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :ubicacion, :string
  end
end
