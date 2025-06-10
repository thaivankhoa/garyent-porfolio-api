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

ActiveRecord::Schema[7.1].define(version: 2025_06_08_075625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string "coingecko_id"
    t.string "symbol"
    t.string "name"
    t.string "image"
    t.decimal "current_price", precision: 30, scale: 10
    t.decimal "market_cap", precision: 30, scale: 2
    t.integer "market_cap_rank"
    t.decimal "total_volume", precision: 30, scale: 2
    t.decimal "high_24h", precision: 30, scale: 10
    t.decimal "low_24h", precision: 30, scale: 10
    t.decimal "price_change_24h", precision: 30, scale: 10
    t.decimal "price_change_percentage_24h", precision: 10, scale: 2
    t.decimal "market_cap_change_24h", precision: 30, scale: 2
    t.decimal "market_cap_change_percentage_24h", precision: 10, scale: 2
    t.decimal "circulating_supply", precision: 30, scale: 2
    t.decimal "total_supply", precision: 30, scale: 2
    t.decimal "max_supply", precision: 30, scale: 2
    t.decimal "ath", precision: 30, scale: 10
    t.decimal "ath_change_percentage", precision: 10, scale: 2
    t.datetime "ath_date"
    t.decimal "atl", precision: 30, scale: 10
    t.decimal "atl_change_percentage", precision: 10, scale: 2
    t.datetime "atl_date"
    t.datetime "last_updated"
    t.decimal "price_change_percentage_1h_in_currency", precision: 10, scale: 2
    t.decimal "price_change_percentage_24h_in_currency", precision: 10, scale: 2
    t.decimal "price_change_percentage_7d_in_currency", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coingecko_id"], name: "index_coins_on_coingecko_id"
    t.index ["name"], name: "index_coins_on_name"
    t.index ["symbol"], name: "index_coins_on_symbol"
  end

  create_table "portfolio_coins", force: :cascade do |t|
    t.bigint "coin_id", null: false
    t.bigint "portfolio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_portfolio_coins_on_coin_id"
    t.index ["portfolio_id"], name: "index_portfolio_coins_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type", limit: 2, null: false
    t.decimal "quantity", precision: 30, scale: 10, null: false
    t.decimal "price", precision: 30, scale: 10, null: false
    t.string "note"
    t.datetime "transaction_date", null: false
    t.bigint "portfolio_coin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_coin_id"], name: "index_transactions_on_portfolio_coin_id"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "portfolio_coins", "coins"
  add_foreign_key "portfolio_coins", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "transactions", "portfolio_coins"
end
