class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.references :army_project, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
