require "test_helper"

class CollectionInventoryTest < ActiveSupport::TestCase
  test "an owned set can create individual miniatures" do
    collection = Collection.create!(name: "My Collection")
    product = CatalogProduct.create!(name: "Combat Patrol")
    owned_set = collection.owned_sets.create!(catalog_product: product)

    miniature = owned_set.miniatures.create!(name: "Bloodletter")

    assert_equal collection, miniature.collection
    assert_equal owned_set, miniature.owned_set
    assert miniature.bought?
  end

  test "miniatures support the hobby status progression" do
    collection = Collection.create!(name: "My Collection")

    miniature = collection.miniatures.create!(name: "Bloodletter", status: :painted)

    assert miniature.painted?
    assert_equal %w[bought built primed painted finished], Miniature.statuses.keys
  end

  test "calculates inclusive progress for an owned set" do
    collection = Collection.create!(name: "My Collection")
    product = CatalogProduct.create!(name: "Combat Patrol")
    owned_set = collection.owned_sets.create!(catalog_product: product)
    %i[bought built primed painted finished].each_with_index do |status, index|
      owned_set.miniatures.create!(name: "Model #{index}", status: status)
    end

    assert_equal 60, owned_set.progress_percentage
  end

  test "catalog products describe their box contents" do
    product = CatalogProduct.create!(name: "Combat Patrol")
    product.catalog_product_models.create!(name: "Bloodletter", quantity: 20)

    assert_equal 20, product.catalog_product_models.first.quantity
  end
end
