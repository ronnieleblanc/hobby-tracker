class MiniaturesController < ApplicationController
  before_action :set_collection
  before_action :set_miniature, only: %i[show edit update]

  def show
  end

  def new
    @miniature = @collection.miniatures.new
    @catalog_units = CatalogUnit.order(:name)
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
