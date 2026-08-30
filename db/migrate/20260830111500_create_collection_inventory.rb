class CreateCollectionInventory < ActiveRecord::Migration[8.1]
  def change
    create_table :collections do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :catalog_products do |t|
      t.references :faction, foreign_key: true
      t.string :name, null: false
      t.string :barcode
      t.string :game_system, null: false, default: "Warhammer 40,000"

      t.timestamps
    end

    add_index :catalog_products, :barcode, unique: true

    create_table :catalog_product_models do |t|
      t.references :catalog_product, null: false, foreign_key: true
      t.references :catalog_unit, foreign_key: true
      t.string :name, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_index :catalog_product_models, [ :catalog_product_id, :name ], unique: true

    create_table :owned_sets do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :catalog_product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    create_table :miniatures do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :owned_set, foreign_key: true
      t.references :catalog_product_model, foreign_key: true
      t.string :name, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
