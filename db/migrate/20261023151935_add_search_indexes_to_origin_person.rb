class AddSearchIndexesToOriginPerson < ActiveRecord::Migration[8.1]
  def change
    add_index :origin_people, :dni
    add_index :origin_people, :fullname
  end
end
