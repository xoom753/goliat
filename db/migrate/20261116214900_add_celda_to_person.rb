class AddCeldaToPerson < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :celda, :string
    change_column :people, :pabellon, :string
  end
end
