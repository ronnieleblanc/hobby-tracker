class AddCatalogProductMetadata < ActiveRecord::Migration[8.1]
  def change
    add_column :catalog_products, :variant, :string, null: false, default: "standard"
    add_column :catalog_products, :source_name, :string
    add_column :catalog_products, :source_url, :string
    add_column :catalog_products, :source_updated_on, :date
  end
end
