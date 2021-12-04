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

ActiveRecord::Schema.define(version: 2021_12_02_072000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "fighter_gears", force: :cascade do |t|
    t.bigint "gear_id", null: false
    t.bigint "fighter_id", null: false
    t.boolean "equiped", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fighter_id"], name: "index_fighter_gears_on_fighter_id"
    t.index ["gear_id"], name: "index_fighter_gears_on_gear_id"
  end

  create_table "fighters", force: :cascade do |t|
    t.string "name"
    t.integer "health_point"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed_attack"
    t.integer "level"
    t.integer "experience"
    t.string "stats_up_array", default: [], array: true
    t.string "gear_stats_array", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fights", force: :cascade do |t|
    t.bigint "red_fighter_id", null: false
    t.bigint "blue_fighter_id", null: false
    t.string "first_fighter"
    t.string "second_fighter"
    t.string "turns", default: [], array: true
    t.string "winner"
    t.string "loser"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blue_fighter_id"], name: "index_fights_on_blue_fighter_id"
    t.index ["red_fighter_id"], name: "index_fights_on_red_fighter_id"
  end

  create_table "gears", force: :cascade do |t|
    t.string "name"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed_attack"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fighter_gears", "fighters"
  add_foreign_key "fighter_gears", "gears"
  add_foreign_key "fights", "fighters", column: "blue_fighter_id"
  add_foreign_key "fights", "fighters", column: "red_fighter_id"
end
