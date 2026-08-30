# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if !Rails.env.production? && Collection.none? && CatalogProduct.none?
  Collection.create!(name: "My Collection")

  demo_set = CatalogProduct.create!(name: "Demo Starter Set")
  demo_set.catalog_product_models.create!(name: "Demo Warrior", quantity: 5)
  demo_set.catalog_product_models.create!(name: "Demo Leader", quantity: 1)
end

unless CatalogProduct.exists?(name: "Combat Patrol: World Eaters", variant: "2024")
  reviewed_set = YAML.safe_load(
    Rails.root.join("db/catalog/combat_patrol_world_eaters_2024.yml").read
  )
  product = CatalogProduct.create!(
    name: reviewed_set.fetch("name"),
    variant: reviewed_set.fetch("variant"),
    game_system: reviewed_set.fetch("game_system"),
    faction: Faction.find_by(slug: reviewed_set["faction_slug"]),
    source_name: reviewed_set.fetch("source_name"),
    source_url: reviewed_set.fetch("source_url")
  )
  reviewed_set.fetch("contents").each do |content|
    product.catalog_product_models.create!(
      name: content.fetch("name"),
      quantity: content.fetch("quantity")
    )
  end
end
