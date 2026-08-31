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

  test "searches and groups catalog units by faction on the add form" do
    other_faction = Faction.create!(name: "Space Marines", slug: "space-marines")
    CatalogUnit.create!(faction: other_faction, name: "Jakhals", slug: "space-marines-jakhals")

    get new_collection_miniature_path(@collection)

    assert_response :success
    assert_select "input[role=combobox][placeholder='Search by faction or unit name']"
    assert_select "[role=listbox][hidden]"
    assert_select "script[data-catalog-unit-combobox-target=data]"
    assert_operator @response.body.index('"faction":"Space Marines"'), :<,
                     @response.body.index('"faction":"World Eaters"')
  end

  test "deletes a standalone miniature" do
    miniature = @collection.miniatures.create!(
      catalog_unit: @catalog_unit,
      name: "World Eaters - Jakhals #1"
    )

    assert_difference("Miniature.count", -1) do
      delete collection_miniature_path(@collection, miniature)
    end

    assert_redirected_to collection_path(@collection)
  end

  test "bulk updates one standalone unit group" do
    first = @collection.miniatures.create!(
      catalog_unit: @catalog_unit,
      name: "World Eaters - Jakhals #1"
    )
    second = @collection.miniatures.create!(
      catalog_unit: @catalog_unit,
      name: "World Eaters - Jakhals #2"
    )

    post collection_update_miniatures_status_path(@collection),
         params: { catalog_unit_id: @catalog_unit.id, status: "painted" }

    assert_redirected_to collection_path(@collection)
    assert_equal "painted", first.reload.status
    assert_equal "painted", second.reload.status
  end

  test "deletes one standalone unit group" do
    @collection.miniatures.create!(
      catalog_unit: @catalog_unit,
      name: "World Eaters - Jakhals #1"
    )
    @collection.miniatures.create!(
      catalog_unit: @catalog_unit,
      name: "World Eaters - Jakhals #2"
    )

    assert_difference("Miniature.count", -2) do
      delete collection_delete_miniatures_group_path(@collection),
             params: { catalog_unit_id: @catalog_unit.id }
    end

    assert_redirected_to collection_path(@collection)
  end
end
