class AddSituacionActualIndexToOriginPerson < ActiveRecord::Migration[8.1]
  def change
    add_index :origin_people, :situacion_actual
  end
end
