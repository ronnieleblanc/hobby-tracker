class CatalogUnit < ApplicationRecord
  belongs_to :faction

  validates :name, :slug, presence: true

  def display_name
    "#{faction.name} - #{name}"
  end
end
