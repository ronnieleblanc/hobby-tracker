class CatalogProduct < ApplicationRecord
  belongs_to :faction, optional: true
  has_many :catalog_product_models, dependent: :destroy
  has_many :owned_sets, dependent: :restrict_with_error

  validates :name, :variant, presence: true
end
