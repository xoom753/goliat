class CreateActivityHumanNames < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_human_names do |t|
      t.references :activity, null: false, foreign_key: true
      t.string :nombre, null: false

      t.datetime :created_at
    end
  end
end
