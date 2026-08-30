namespace :catalog do
  desc "Import one reviewed catalog product YAML file"
  task import: :environment do
    require "date"
    require "yaml"

    file_path = ENV.fetch("FILE") { raise "Usage: bin/rails catalog:import FILE=path/to/product.yml" }
    data = YAML.safe_load(File.read(file_path), permitted_classes: [ Date ])
    faction = Faction.find_by(slug: data["faction_slug"]) if data["faction_slug"]

    product = CatalogProduct.find_or_initialize_by(
      name: data.fetch("name"),
      variant: data.fetch("variant", "standard")
    )
    product.assign_attributes(
      barcode: data["barcode"],
      faction: faction,
      game_system: data.fetch("game_system", "Warhammer 40,000"),
      source_name: data["source_name"],
      source_url: data["source_url"],
      source_updated_on: data["source_updated_on"]
    )

    CatalogProduct.transaction do
      product.save!
      product.catalog_product_models.delete_all
      data.fetch("contents").each do |content|
        catalog_unit = faction&.catalog_units&.find_by(name: content.fetch("name"))
        product.catalog_product_models.create!(
          catalog_unit: catalog_unit,
          name: content.fetch("name"),
          quantity: content.fetch("quantity")
        )
      end
    end

    puts "Imported #{product.name} (#{product.variant}) with #{product.catalog_product_models.count} contents."
  end
end
