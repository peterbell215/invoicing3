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

ActiveRecord::Schema[7.0].define(version: 2024_06_16_153928) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_sessions", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "start", null: false
    t.integer "duration", null: false
    t.integer "current_rate_pence", default: 0, null: false
    t.string "current_rate_currency", default: "GBP", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_id"
    t.index ["client_id"], name: "index_client_sessions_on_client_id"
    t.index ["invoice_id"], name: "index_client_sessions_on_invoice_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "town"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "title"
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "fees", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.date "from"
    t.date "to"
    t.integer "hourly_charge_rate_pence", default: 0, null: false
    t.string "hourly_charge_rate_currency", default: "GBP", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_fees_on_client_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "date"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_pence", default: 0, null: false
    t.string "amount_currency", default: "GBP", null: false
    t.integer "status", default: 0, null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "client_sessions", "clients"
  add_foreign_key "client_sessions", "invoices"
  add_foreign_key "fees", "clients"
  add_foreign_key "invoices", "clients"
end
