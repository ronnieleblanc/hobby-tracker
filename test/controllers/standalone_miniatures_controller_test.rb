require "test_helper"

class StandaloneMiniaturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = Collection.create!(name: "My Collection")
    @catalog_unit = CatalogUnit.create!(
      faction: Faction.create!(name: "World Eaters", slug: "world-eaters"),
      name: "Jakhals",
      slug: "jakhals"
    )
  end

  test "adds a quantity of standalone miniatures" do
    assert_difference("Miniature.count", 3) do
      post collection_miniatures_path(@collection),
           params: { miniature: { catalog_unit_id: @catalog_unit.id, quantity: 3 } }
    end

    assert_redirected_to collection_path(@collection)
    assert_equal [ "World Eaters - Jakhals #1", "World Eaters - Jakhals #2", "World Eaters - Jakhals #3" ],
                 @collection.reload.miniatures.order(:position).pluck(:name)
  end
end
