class Faction < ApplicationRecord
  has_many :catalog_units, dependent: :destroy

  validates :name, :slug, presence: true
end
