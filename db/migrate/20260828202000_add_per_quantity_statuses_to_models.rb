class AddPerQuantityStatusesToModels < ActiveRecord::Migration[8.1]
  def up
    add_column :models, :not_started_quantity, :integer, null: false, default: 0
    add_column :models, :in_progress_quantity, :integer, null: false, default: 0
    add_column :models, :completed_quantity, :integer, null: false, default: 0

    execute <<~SQL
      UPDATE models
      SET completed_quantity = CASE WHEN completed THEN quantity ELSE 0 END,
          not_started_quantity = CASE WHEN completed THEN 0 ELSE quantity END
    SQL

    remove_column :models, :completed
  end

  def down
    add_column :models, :completed, :boolean, null: false, default: false

    execute <<~SQL
      UPDATE models
      SET completed = (completed_quantity = quantity)
    SQL

    remove_column :models, :not_started_quantity
    remove_column :models, :in_progress_quantity
    remove_column :models, :completed_quantity
  end
end
