class AddPersonIdsToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :people_ids, :string
  end
end
