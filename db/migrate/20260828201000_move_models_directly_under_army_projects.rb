class MoveModelsDirectlyUnderArmyProjects < ActiveRecord::Migration[8.1]
  def up
    add_reference :models, :army_project, foreign_key: true

    execute <<~SQL
      UPDATE models
      SET army_project_id = units.army_project_id
      FROM units
      WHERE models.unit_id = units.id
    SQL

    change_column_null :models, :army_project_id, false
    remove_foreign_key :models, :unit, if_exists: true
    remove_reference :models, :unit, foreign_key: false
    drop_table :units
  end

  def down
    create_table :units do |t|
      t.references :army_project, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_reference :models, :unit, foreign_key: true

    execute <<~SQL
      INSERT INTO units (army_project_id, name, created_at, updated_at)
      SELECT DISTINCT army_project_id, 'Imported Unit', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM models
    SQL

    execute <<~SQL
      UPDATE models
      SET unit_id = units.id
      FROM units
      WHERE models.army_project_id = units.army_project_id
    SQL

    change_column_null :models, :unit_id, false
    remove_foreign_key :models, :army_project
    remove_reference :models, :army_project, foreign_key: false
  end
end
