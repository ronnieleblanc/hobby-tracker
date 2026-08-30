class CatalogProductModel < ApplicationRecord
  belongs_to :catalog_product
  belongs_to :catalog_unit, optional: true
  has_many :miniatures, dependent: :nullify

  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
