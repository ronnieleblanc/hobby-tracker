# Hobby Tracker

A small Rails/PostgreSQL application for tracking Warhammer miniatures from
boxed sets and individual model additions.

## Requirements

- Ruby version listed in `.ruby-version`
- Rails and Bundler
- PostgreSQL

## Setup

From the project directory:

```bash
bin/setup
bin/rails db:seed
bin/rails server
```

The application is currently web-first. The root page shows collections, owned
sets, standalone miniatures, status counts, and progress.

## Tests

```bash
bin/rails test
```

## Catalog data

The optional catalog sync imports faction and unit names from the
[BSData WH40K 11th Edition Munitorum Field Manual repository](https://github.com/BSData/wh40k-11e-mfm/tree/main/data):

```bash
bin/rails warhammer:sync_catalog
```

Reviewed boxed-set fixtures can be imported with:

```bash
bin/rails catalog:import FILE=db/catalog/combat_patrol_world_eaters_2024.yml
```

Catalog units are scoped to their faction. Standalone miniatures include the
faction in their name so units with the same name in different armies remain
distinct.

The BSData repository is unofficial and MIT-licensed. Warhammer 40,000 and
related content belong to Games Workshop.

## Warhammer catalog data

The optional catalog sync task imports faction and unit names from the
[BSData WH40K 11th Edition Munitorum Field Manual repository](https://github.com/BSData/wh40k-11e-mfm/tree/main/data):

```bash
bin/rails warhammer:sync_catalog
```

The imported names are stored locally so the application does not require the
source repository at page-render time. If this becomes a live service, the
sync task could be run on a scheduled cadence and changes reviewed before
updating the catalog. The source repository is MIT-licensed, unofficial, and
notes that Warhammer 40,000 and the underlying content belong to Games Workshop.
