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

ActiveRecord::Schema.define(version: 1020) do

  create_table "comments", force: :cascade do |t|
    t.integer  "item_id"
    t.text     "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "item_name"
    t.integer  "item_condition"
    t.string   "item_description"
    t.integer  "item_price_in_cents"
    t.integer  "item_purchase_state"
    t.string   "item_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "user_password"
    t.string   "user_salt"
    t.string   "user_unique_key"
    t.string   "email_address"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
