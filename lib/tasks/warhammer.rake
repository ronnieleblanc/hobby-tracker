namespace :warhammer do
  desc "Sync faction and unit names from the BSData Warhammer 40,000 repository"
  task sync_catalog: :environment do
    require "net/http"
    require "uri"
    require "yaml"
    require "date"

    base_url = "https://raw.githubusercontent.com/BSData/wh40k-11e-mfm/main/data"
    fetch_yaml = lambda do |uri|
      response = Net::HTTP.get_response(uri)
      raise "BSData request failed (#{response.code}) for #{uri}" unless response.is_a?(Net::HTTPSuccess)

      YAML.safe_load(response.body, permitted_classes: [ Date ])
    end

    meta = fetch_yaml.call(URI("#{base_url}/meta.yaml"))

    meta.fetch("factions").each do |slug|
      data = fetch_yaml.call(URI("#{base_url}/#{slug}.yaml"))
      faction = Faction.find_or_initialize_by(slug: slug)
      faction.update!(name: data.fetch("name"), source_updated_on: data["lastUpdated"])

      data.fetch("units", []).each do |unit_data|
        name = unit_data.fetch("name")
        faction.catalog_units.find_or_create_by!(name: name, slug: name.parameterize)
      end

      puts "#{faction.name}: #{faction.catalog_units.count} units"
    end
  end
end
