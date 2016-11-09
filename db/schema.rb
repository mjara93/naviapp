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

ActiveRecord::Schema.define(version: 20161108205425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email"
    t.string   "contraseña"
    t.integer  "crew_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "accounts", ["crew_id"], name: "index_accounts_on_crew_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "rut"
    t.text     "nombre"
    t.integer  "telefono"
    t.string   "direccion"
    t.integer  "numero"
    t.integer  "city_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "clients", ["city_id"], name: "index_clients_on_city_id", using: :btree

  create_table "costs", force: :cascade do |t|
    t.integer  "alimentacion"
    t.integer  "combustible"
    t.integer  "personal"
    t.integer  "emergencia"
    t.integer  "trip_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "costs", ["trip_id"], name: "index_costs_on_trip_id", using: :btree

  create_table "crews", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apaterno"
    t.string   "amaterno"
    t.string   "email"
    t.string   "rut"
    t.integer  "celular"
    t.string   "direccion"
    t.integer  "city_id"
    t.integer  "position_id"
    t.integer  "ship_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "crews", ["city_id"], name: "index_crews_on_city_id", using: :btree
  add_index "crews", ["position_id"], name: "index_crews_on_position_id", using: :btree
  add_index "crews", ["ship_id"], name: "index_crews_on_ship_id", using: :btree

  create_table "details", force: :cascade do |t|
    t.float    "cantidad"
    t.integer  "precio"
    t.integer  "subtotal"
    t.integer  "product_id"
    t.integer  "sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "details", ["product_id"], name: "index_details_on_product_id", using: :btree
  add_index "details", ["sale_id"], name: "index_details_on_sale_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.float    "longitud"
    t.float    "latitud"
    t.datetime "hora"
    t.integer  "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "locations", ["trip_id"], name: "index_locations_on_trip_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string   "rut"
    t.text     "nombre"
    t.string   "direccion"
    t.integer  "numero"
    t.integer  "city_id"
    t.string   "email"
    t.integer  "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "providers", ["city_id"], name: "index_providers_on_city_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "factura"
    t.integer  "total"
    t.integer  "provider_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "purchases", ["provider_id"], name: "index_purchases_on_provider_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.integer  "factura"
    t.date     "fecha"
    t.integer  "total"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sales", ["client_id"], name: "index_sales_on_client_id", using: :btree

  create_table "ships", force: :cascade do |t|
    t.string   "nombre"
    t.string   "patente"
    t.integer  "metros"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summaries", force: :cascade do |t|
    t.float    "cantidad"
    t.integer  "precio"
    t.integer  "subtotal"
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "summaries", ["product_id"], name: "index_summaries_on_product_id", using: :btree
  add_index "summaries", ["purchase_id"], name: "index_summaries_on_purchase_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.date     "salida"
    t.date     "real"
    t.date     "estimada"
    t.string   "motivo"
    t.integer  "ship_id"
    t.integer  "purchase_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "trips", ["purchase_id"], name: "index_trips_on_purchase_id", using: :btree
  add_index "trips", ["ship_id"], name: "index_trips_on_ship_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "nombre"
    t.string   "apellidoPaterno"
    t.string   "apellidoMaterno"
    t.string   "rut"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "accounts", "crews"
  add_foreign_key "clients", "cities"
  add_foreign_key "costs", "trips"
  add_foreign_key "crews", "cities"
  add_foreign_key "crews", "positions"
  add_foreign_key "crews", "ships"
  add_foreign_key "details", "products"
  add_foreign_key "details", "sales"
  add_foreign_key "locations", "trips"
  add_foreign_key "providers", "cities"
  add_foreign_key "purchases", "providers"
  add_foreign_key "sales", "clients"
  add_foreign_key "summaries", "products"
  add_foreign_key "summaries", "purchases"
  add_foreign_key "trips", "purchases"
  add_foreign_key "trips", "ships"
end
