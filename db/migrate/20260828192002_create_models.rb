class CreateModels < ActiveRecord::Migration[8.1]
  def change
    create_table :models do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
