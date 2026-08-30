# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_30_181000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "army_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "faction", default: "Other", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalog_product_models", force: :cascade do |t|
    t.bigint "catalog_product_id", null: false
    t.bigint "catalog_unit_id"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_product_id", "name"], name: "index_catalog_product_models_on_catalog_product_id_and_name", unique: true
    t.index ["catalog_product_id"], name: "index_catalog_product_models_on_catalog_product_id"
    t.index ["catalog_unit_id"], name: "index_catalog_product_models_on_catalog_unit_id"
  end

  create_table "catalog_products", force: :cascade do |t|
    t.string "barcode"
    t.datetime "created_at", null: false
    t.bigint "faction_id"
    t.string "game_system", default: "Warhammer 40,000", null: false
    t.string "name", null: false
    t.string "source_name"
    t.date "source_updated_on"
    t.string "source_url"
    t.datetime "updated_at", null: false
    t.string "variant", default: "standard", null: false
    t.index ["barcode"], name: "index_catalog_products_on_barcode", unique: true
    t.index ["faction_id"], name: "index_catalog_products_on_faction_id"
  end

  create_table "catalog_units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "faction_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["faction_id", "name"], name: "index_catalog_units_on_faction_id_and_name", unique: true
    t.index ["faction_id"], name: "index_catalog_units_on_faction_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.date "source_updated_on"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_factions_on_slug", unique: true
  end

  create_table "miniatures", force: :cascade do |t|
    t.bigint "catalog_product_model_id"
    t.bigint "catalog_unit_id"
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "owned_set_id"
    t.integer "position"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_product_model_id"], name: "index_miniatures_on_catalog_product_model_id"
    t.index ["catalog_unit_id"], name: "index_miniatures_on_catalog_unit_id"
    t.index ["collection_id"], name: "index_miniatures_on_collection_id"
    t.index ["owned_set_id"], name: "index_miniatures_on_owned_set_id"
  end

  create_table "models", force: :cascade do |t|
    t.bigint "army_project_id", null: false
    t.integer "basing_completed_quantity", default: 0, null: false
    t.integer "basing_in_progress_quantity", default: 0, null: false
    t.integer "basing_not_started_quantity", default: 0, null: false
    t.integer "building_completed_quantity", default: 0, null: false
    t.integer "building_in_progress_quantity", default: 0, null: false
    t.integer "building_not_started_quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "painting_completed_quantity", default: 0, null: false
    t.integer "painting_in_progress_quantity", default: 0, null: false
    t.integer "painting_not_started_quantity", default: 0, null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["army_project_id"], name: "index_models_on_army_project_id"
  end

  create_table "owned_sets", force: :cascade do |t|
    t.bigint "catalog_product_id", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_product_id"], name: "index_owned_sets_on_catalog_product_id"
    t.index ["collection_id"], name: "index_owned_sets_on_collection_id"
  end

  add_foreign_key "catalog_product_models", "catalog_products"
  add_foreign_key "catalog_product_models", "catalog_units"
  add_foreign_key "catalog_products", "factions"
  add_foreign_key "catalog_units", "factions"
  add_foreign_key "miniatures", "catalog_product_models"
  add_foreign_key "miniatures", "catalog_units"
  add_foreign_key "miniatures", "collections"
  add_foreign_key "miniatures", "owned_sets"
  add_foreign_key "models", "army_projects"
  add_foreign_key "owned_sets", "catalog_products"
  add_foreign_key "owned_sets", "collections"
end
