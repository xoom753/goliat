class AddSearchIndexesToPerson < ActiveRecord::Migration[8.1]
  def change
    add_index :people, :dni
    add_index :people, :nombres
  end
end
