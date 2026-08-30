class AddCatalogUnitToMiniatures < ActiveRecord::Migration[8.1]
  def change
    add_reference :miniatures, :catalog_unit, foreign_key: true
  end
end
