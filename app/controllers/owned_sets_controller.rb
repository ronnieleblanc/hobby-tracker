class OwnedSetsController < ApplicationController
  before_action :set_collection
  before_action :set_owned_set, only: %i[show update_status destroy]

  def new
    @owned_set = @collection.owned_sets.new
    @catalog_products = CatalogProduct.order(:name)
  end

  def create
    @owned_set = @collection.owned_sets.new(owned_set_params)

    if @owned_set.save
      redirect_to @collection, notice: "Set was added and its miniatures were created."
    else
      @catalog_products = CatalogProduct.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @miniatures = @owned_set.miniatures.includes(:catalog_product_model)
                              .order(:catalog_product_model_id, :position)
    @miniature_groups = @miniatures.group_by(&:catalog_product_model)
  end

  def update_status
    status = params[:status]
    raise ActionController::BadRequest, "Invalid miniature status" unless Miniature.statuses.key?(status)

    miniatures = @owned_set.miniatures
    if params[:catalog_product_model_id].present?
      miniatures = miniatures.where(catalog_product_model_id: params[:catalog_product_model_id])
      raise ActiveRecord::RecordNotFound if miniatures.none?
    end

    miniatures.update_all(status: Miniature.statuses.fetch(status), updated_at: Time.current)
    redirect_to [ @collection, @owned_set ], notice: "Miniature statuses were updated."
  end

  def destroy
    @owned_set.destroy
    redirect_to @collection, notice: "Set was removed from the collection."
  end

  private

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def set_owned_set
    @owned_set = @collection.owned_sets.find(params[:id])
  end

  def owned_set_params
    params.expect(owned_set: [ :catalog_product_id, :quantity ])
  end
end
