class OwnedSet < ApplicationRecord
  belongs_to :collection
  belongs_to :catalog_product
  has_many :miniatures, dependent: :destroy

  after_create :create_miniatures

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def progress_percentage
    return 0 if miniatures.empty?

    (miniatures.sum(&:progress_percentage).to_f / miniatures.size).round
  end

  private

  def create_miniatures
    catalog_product.catalog_product_models.find_each do |product_model|
      (product_model.quantity * quantity).times do |index|
        miniatures.create!(
          collection: collection,
          catalog_product_model: product_model,
          name: "#{product_model.name} ##{index + 1}",
          position: index + 1
        )
      end
    end
  end
end
