require "test_helper"

class OwnedSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = Collection.create!(name: "My Collection")
    @product = CatalogProduct.create!(name: "Combat Patrol")
    @product.catalog_product_models.create!(name: "Bloodletter", quantity: 20)
  end

  test "adds a set and expands its contents into miniatures" do
    assert_difference("Miniature.count", 20) do
      post collection_owned_sets_path(@collection),
           params: { owned_set: { catalog_product_id: @product.id, quantity: 1 } }
    end

    assert_redirected_to collection_path(@collection)
    assert_equal 20, @collection.reload.miniatures.count
  end

  test "bulk updates miniature status for an owned set" do
    owned_set = @collection.owned_sets.create!(catalog_product: @product)

    post update_status_collection_owned_set_path(@collection, owned_set),
         params: { status: "built" }

    assert_redirected_to collection_owned_set_path(@collection, owned_set)
    assert_equal 20, owned_set.reload.miniatures.built.count
  end

  test "bulk updates one model group within an owned set" do
    second_model = @product.catalog_product_models.create!(name: "Jakhals", quantity: 10)
    owned_set = @collection.owned_sets.create!(catalog_product: @product)

    post update_status_collection_owned_set_path(@collection, owned_set),
         params: { status: "primed", catalog_product_model_id: second_model.id }

    assert_redirected_to collection_owned_set_path(@collection, owned_set)
    assert_equal 10, owned_set.reload.miniatures.primed.where(catalog_product_model: second_model).count
    assert_equal 20, owned_set.miniatures.bought.where.not(catalog_product_model: second_model).count
  end

  test "deletes an owned set and its miniatures" do
    owned_set = @collection.owned_sets.create!(catalog_product: @product)

    assert_difference("OwnedSet.count", -1) do
      assert_difference("Miniature.count", -20) do
        delete collection_owned_set_path(@collection, owned_set)
      end
    end

    assert_redirected_to collection_path(@collection)
  end

  test "shows a set and its miniatures" do
    owned_set = @collection.owned_sets.create!(catalog_product: @product)

    get collection_owned_set_path(@collection, owned_set)

    assert_response :success
    assert_select "h1", "Combat Patrol"
    assert_select "p", /Progress: 20% complete/
    assert_select "li", /Bloodletter #1/
    assert_operator @response.body.index("Bloodletter #9"), :<,
                     @response.body.index("Bloodletter #10")
  end
end
