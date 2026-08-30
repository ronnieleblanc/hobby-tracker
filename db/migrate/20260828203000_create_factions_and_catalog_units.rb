class CreateFactionsAndCatalogUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :factions do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.date :source_updated_on

      t.timestamps
    end

    add_index :factions, :slug, unique: true

    create_table :catalog_units do |t|
      t.references :faction, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :catalog_units, [ :faction_id, :name ], unique: true
  end
end
