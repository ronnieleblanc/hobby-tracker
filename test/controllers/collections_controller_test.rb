require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "shows collection progress by miniature status" do
    collection = Collection.create!(name: "My Collection")
    collection.miniatures.create!(name: "Bloodletter", status: :painted)

    get collection_path(collection)

    assert_response :success
    assert_select "li", /Painted: 1/
    assert_select "p", "No sets added yet."
  end

  test "groups standalone miniatures by faction and unit" do
    faction = Faction.create!(name: "World Eaters", slug: "world-eaters")
    catalog_unit = CatalogUnit.create!(faction: faction, name: "Jakhals", slug: "jakhals")
    collection = Collection.create!(name: "My Collection")
    collection.miniatures.create!(catalog_unit: catalog_unit, name: "World Eaters - Jakhals #1")

    get collection_path(collection)

    assert_response :success
    assert_select "h3", "World Eaters"
    assert_select "summary", /Jakhals × 1/
  end
end
