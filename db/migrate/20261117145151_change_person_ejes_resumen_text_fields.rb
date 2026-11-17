class ChangePersonEjesResumenTextFields < ActiveRecord::Migration[8.1]
  def change
    change_column :person_ejes_resumenes, :nombres, :string
    change_column :person_ejes_resumenes, :dni, :string
    change_column :person_ejes_resumenes, :ubicacion, :string
    change_column :person_ejes_resumenes, :ubicacion_traslado, :string
    add_column :person_ejes_resumenes, :fechas_ingresos_y_egresos, :text
  end
end
