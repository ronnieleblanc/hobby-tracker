class PrefixStandaloneMiniatureNames < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE miniatures
      SET name = factions.name || ' - ' || miniatures.name
      FROM catalog_units
      INNER JOIN factions ON factions.id = catalog_units.faction_id
      WHERE miniatures.catalog_unit_id = catalog_units.id
        AND miniatures.owned_set_id IS NULL
        AND miniatures.name NOT LIKE factions.name || ' - %'
    SQL
  end

  def down
    # This migration changes display names and cannot safely infer the original names.
  end
end
