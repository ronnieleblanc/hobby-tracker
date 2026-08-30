class CreateArmyProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :army_projects do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
