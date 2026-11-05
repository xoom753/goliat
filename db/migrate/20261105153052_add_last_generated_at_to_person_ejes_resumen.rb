class AddLastGeneratedAtToPersonEjesResumen < ActiveRecord::Migration[8.1]
  def change
    add_column :person_ejes_resumenes, :last_generated_at, :datetime
  end
end
