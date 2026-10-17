class CreateImportErrors < ActiveRecord::Migration[8.1]
  def change
    create_table :import_errors do |t|
      t.text :details

      t.timestamps
    end
  end
end
