class AddFactionToArmyProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :army_projects, :faction, :string, null: false, default: "Other"
  end
end
