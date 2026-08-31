class MiniaturesController < ApplicationController
  before_action :set_collection
  before_action :set_miniature, only: %i[show edit update destroy]

  def show
  end

  def new
    @miniature = @collection.miniatures.new
    @catalog_units = CatalogUnit.joins(:faction).includes(:faction).order("factions.name", "catalog_units.name")
  end

  def create
    catalog_unit = CatalogUnit.find(miniature_params.fetch(:catalog_unit_id))
    quantity = Integer(miniature_params.fetch(:quantity), 10)
    raise ActionController::BadRequest, "Quantity must be positive" unless quantity.positive?

    quantity.times do |index|
      @collection.miniatures.create!(
        catalog_unit: catalog_unit,
        name: "#{catalog_unit.display_name} ##{index + 1}",
        position: index + 1
      )
    end
    redirect_to @collection, notice: "Individual miniatures were added."
  rescue ArgumentError, TypeError
    raise ActionController::BadRequest, "Quantity must be a whole number"
  end

  def edit
  end

  def update
    if @miniature.update(miniature_params)
      redirect_to [ @collection, @miniature ], notice: "Miniature status was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    raise ActionController::BadRequest, "Set miniatures must be removed with their set" if @miniature.owned_set.present?

    @miniature.destroy!
    redirect_to @collection, notice: "Standalone miniature was removed."
  end

  def update_status_group
    status = params[:status]
    raise ActionController::BadRequest, "Invalid miniature status" unless Miniature.statuses.key?(status)

    miniatures = @collection.miniatures.where(
      owned_set_id: nil,
      catalog_unit_id: params[:catalog_unit_id]
    )
    raise ActiveRecord::RecordNotFound if miniatures.none?

    miniatures.update_all(status: Miniature.statuses.fetch(status), updated_at: Time.current)
    redirect_to @collection, notice: "Standalone miniature statuses were updated."
  end

  def destroy_group
    miniatures = @collection.miniatures.where(
      owned_set_id: nil,
      catalog_unit_id: params[:catalog_unit_id]
    )
    raise ActiveRecord::RecordNotFound if miniatures.none?

    miniatures.destroy_all
    redirect_to @collection, notice: "Standalone miniature group was removed."
  end

  private

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def set_miniature
    @miniature = @collection.miniatures.find(params[:id])
  end

  def miniature_params
    params.expect(miniature: [ :status, :catalog_unit_id, :quantity ])
  end
end
