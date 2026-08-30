class AddPositionToMiniatures < ActiveRecord::Migration[8.1]
  def change
    add_column :miniatures, :position, :integer
  end
end
