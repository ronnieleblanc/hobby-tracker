class Collection < ApplicationRecord
  has_many :owned_sets, dependent: :destroy
  has_many :miniatures, dependent: :destroy

  validates :name, presence: true

  def status_counts
    Miniature.statuses.keys.index_with do |status|
      miniatures.public_send(status).count
    end
  end
end
