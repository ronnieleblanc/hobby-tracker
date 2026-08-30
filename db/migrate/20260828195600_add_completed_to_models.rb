class AddCompletedToModels < ActiveRecord::Migration[8.1]
  def change
    add_column :models, :completed, :boolean, null: false, default: false
  end
end
