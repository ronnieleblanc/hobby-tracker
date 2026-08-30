class Miniature < ApplicationRecord
  STATUS_PROGRESS = {
    "bought" => 20,
    "built" => 40,
    "primed" => 60,
    "painted" => 80,
    "finished" => 100
  }.freeze

  belongs_to :collection
  belongs_to :owned_set, optional: true
  belongs_to :catalog_product_model, optional: true
  belongs_to :catalog_unit, optional: true

  enum :status, { bought: 0, built: 1, primed: 2, painted: 3, finished: 4 }

  before_validation :inherit_collection_from_owned_set

  validates :name, presence: true

  def progress_percentage
    STATUS_PROGRESS.fetch(status)
  end

  private

  def inherit_collection_from_owned_set
    self.collection ||= owned_set&.collection
  end
end
