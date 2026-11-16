class AddSexoToOriginPerson < ActiveRecord::Migration[8.1]
  def change
    add_column :origin_people, :sexo, :integer
  end
end
