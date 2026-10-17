class CreatePersonPabellonUpdates < ActiveRecord::Migration[8.1]
  def change
    create_table :person_pabellon_updates do |t|
      t.string :nombres
      t.string :pabellon

      t.datetime :created_at, null: false
    end
  end
end
