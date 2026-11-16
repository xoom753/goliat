class AddCeldaToPersonPabellonUpdate < ActiveRecord::Migration[8.1]
  def change
    add_column :person_pabellon_updates, :celda, :string
  end
end
