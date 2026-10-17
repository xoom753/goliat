class CreatePersonActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :person_activities do |t|
      t.references :person, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.integer :mes, null: false
      t.integer :anio, null: false
      t.integer :cargo, default: 0
      t.string :qty_h

      # t.timestamps
    end
  end
end
