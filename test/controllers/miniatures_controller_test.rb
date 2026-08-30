require "test_helper"

class MiniaturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = Collection.create!(name: "My Collection")
    @miniature = @collection.miniatures.create!(name: "Bloodletter")
  end

  test "updates one miniature status" do
    patch collection_miniature_path(@collection, @miniature),
          params: { miniature: { status: "painted" } }

    assert_redirected_to collection_miniature_path(@collection, @miniature)
    assert @miniature.reload.painted?
  end

  test "shows one miniature status" do
    get collection_miniature_path(@collection, @miniature)

    assert_response :success
    assert_select "p", /Status: Bought/
  end
end
