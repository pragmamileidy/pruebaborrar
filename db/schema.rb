# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150225201255) do

  create_table "cards", force: true do |t|
    t.string   "card_type"
    t.integer  "number"
    t.integer  "code"
    t.date     "date_expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "identification"
    t.text     "address1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_id"
  end

  add_index "customers", ["card_id"], name: "index_customers_on_card_id"
  add_index "customers", ["identification"], name: "index_customers_on_identification", unique: true

  create_table "merchants", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "name"
    t.integer  "account"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "payments", force: true do |t|
    t.float    "amount"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.integer  "customer_id"
    t.string   "status"
  end

  add_index "payments", ["customer_id"], name: "index_payments_on_customer_id"
  add_index "payments", ["merchant_id"], name: "index_payments_on_merchant_id"

end
