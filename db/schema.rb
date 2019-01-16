# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_16_193355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ask_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_ask_items_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "hn_id"
    t.bigint "parent_id"
    t.boolean "deleted"
    t.integer "hn_type"
    t.string "by"
    t.datetime "time"
    t.text "text"
    t.boolean "dead"
    t.bigint "parent"
    t.bigint "poll"
    t.string "url"
    t.string "host"
    t.integer "score"
    t.string "title"
    t.integer "descendants"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kid_location"
    t.boolean "loading_details", default: false
  end

  create_table "job_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_job_items_on_item_id"
  end

  create_table "new_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_new_items_on_item_id"
  end

  create_table "show_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_show_items_on_item_id"
  end

  create_table "top_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_top_items_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "hn_id"
    t.datetime "created"
    t.bigint "delay"
    t.bigint "karma"
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ask_items", "items"
  add_foreign_key "job_items", "items"
  add_foreign_key "new_items", "items"
  add_foreign_key "show_items", "items"
  add_foreign_key "top_items", "items"
end
