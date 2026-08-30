class AddStageProgressToModels < ActiveRecord::Migration[8.1]
  STAGES = %w[building basing painting].freeze
  STATUSES = %w[not_started in_progress completed].freeze

  def up
    STAGES.product(STATUSES).each do |stage, status|
      add_column :models, :"#{stage}_#{status}_quantity", :integer, null: false, default: 0
    end

    execute <<~SQL
      UPDATE models
      SET building_not_started_quantity = quantity,
          basing_not_started_quantity = quantity,
          painting_not_started_quantity = not_started_quantity,
          painting_in_progress_quantity = in_progress_quantity,
          painting_completed_quantity = completed_quantity
    SQL

    remove_column :models, :not_started_quantity
    remove_column :models, :in_progress_quantity
    remove_column :models, :completed_quantity
  end

  def down
    add_column :models, :not_started_quantity, :integer, null: false, default: 0
    add_column :models, :in_progress_quantity, :integer, null: false, default: 0
    add_column :models, :completed_quantity, :integer, null: false, default: 0

    execute <<~SQL
      UPDATE models
      SET not_started_quantity = painting_not_started_quantity,
          in_progress_quantity = painting_in_progress_quantity,
          completed_quantity = painting_completed_quantity
    SQL

    STAGES.product(STATUSES).each do |stage, status|
      remove_column :models, :"#{stage}_#{status}_quantity"
    end
  end
end
