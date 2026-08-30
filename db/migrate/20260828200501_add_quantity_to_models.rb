class AddQuantityToModels < ActiveRecord::Migration[8.1]
  def change
    add_column :models, :quantity, :integer, null: false, default: 1
  end
end
