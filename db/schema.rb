# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_17_140644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventory_items", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "survivor_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id"
    t.index ["survivor_id"], name: "index_inventory_items_on_survivor_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "survivor_id", null: false
    t.decimal "lat"
    t.decimal "lng"
    t.index ["survivor_id"], name: "index_locations_on_survivor_id"
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "inventory_items", "items"
  add_foreign_key "inventory_items", "survivors"
  add_foreign_key "locations", "survivors"
end
