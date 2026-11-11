class CreateExtranjeroPresentes < ActiveRecord::Migration[8.1]
  def change
    create_table :extranjero_presentes do |t|
      t.string :nombres
      t.string :pasaporte

      t.timestamps
    end
  end
end
