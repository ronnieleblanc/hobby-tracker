class CollectionsController < ApplicationController
  before_action :set_collection, only: :show

  def index
    @collections = Collection.order(:name)
  end

  def show
    @owned_sets = @collection.owned_sets.includes(:catalog_product).order(created_at: :desc)
    @standalone_miniatures = @collection.miniatures
                                       .where(owned_set_id: nil)
                                       .joins(catalog_unit: :faction)
                                       .includes(catalog_unit: :faction)
                                       .order("factions.name", "catalog_units.name", :position)
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
