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

ActiveRecord::Schema[8.1].define(version: 2026_05_12_103000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "action"
    t.string "browser"
    t.string "controller"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "note"
    t.text "params"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "card_emails", force: :cascade do |t|
    t.string "address"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_emails_on_card_id"
  end

  create_table "card_phones", force: :cascade do |t|
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.integer "location"
    t.string "nmbr"
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_phones_on_card_id"
  end

  create_table "card_socials", force: :cascade do |t|
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.integer "kind"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["card_id"], name: "index_card_socials_on_card_id"
  end

  create_table "card_websites", force: :cascade do |t|
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["card_id"], name: "index_card_websites_on_card_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "address_color"
    t.text "advanced_data"
    t.string "background"
    t.string "background1_color"
    t.string "background2_color"
    t.boolean "background_tile"
    t.string "card_name"
    t.datetime "created_at", null: false
    t.string "details_color"
    t.string "first_name"
    t.string "handed"
    t.string "highlights"
    t.string "hometown"
    t.string "icon_color"
    t.string "image"
    t.string "last_name"
    t.string "league"
    t.integer "membership_id"
    t.string "name_color"
    t.string "position"
    t.string "season"
    t.string "sport"
    t.string "team_name"
    t.datetime "updated_at", null: false
    t.string "url_alias"
    t.bigint "user_id"
    t.string "user_token"
    t.string "year"
    t.index ["url_alias"], name: "index_cards_on_url_alias"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["card_id"], name: "index_contacts_on_card_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0
    t.datetime "created_at", null: false
    t.datetime "failed_at"
    t.text "handler"
    t.text "last_error"
    t.datetime "locked_at"
    t.string "locked_by"
    t.integer "priority", default: 0
    t.string "queue"
    t.datetime "run_at"
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "memberships", force: :cascade do |t|
    t.boolean "admin"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.integer "card_id"
    t.integer "cards_purchased"
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "paid_to"
    t.integer "parent_id"
    t.integer "period", default: 8
    t.integer "status"
    t.string "stripe_customer_token"
    t.string "transaction_number"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "promo_codes", force: :cascade do |t|
    t.integer "cards", default: 1
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "used", default: false
    t.integer "user_id"
  end

  create_table "public_kiosks", force: :cascade do |t|
    t.string "background"
    t.boolean "background_tile"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "logo"
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_public_kiosks_on_team_id"
  end

  create_table "public_pages", force: :cascade do |t|
    t.string "background"
    t.boolean "background_tile"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.string "logo"
    t.boolean "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_public_pages_on_user_id"
  end

  create_table "saved_cards", force: :cascade do |t|
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "data"
    t.string "session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shares", force: :cascade do |t|
    t.integer "contact_card"
    t.datetime "created_at", null: false
    t.string "destination_email"
    t.text "message"
    t.bigint "shareable_id"
    t.string "shareable_type"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["shareable_type", "shareable_id"], name: "index_shares_on_shareable"
  end

  create_table "stats", force: :cascade do |t|
    t.string "abbr"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.string "kind"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["card_id"], name: "index_stats_on_card_id"
  end

  create_table "team_payments", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "memberships_purchased"
    t.integer "status"
    t.string "stripe_customer_token"
    t.bigint "team_id"
    t.string "transaction_number"
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_payments_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "memberships_purchased"
    t.string "name"
    t.integer "owner_id"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "cards_purchased"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "first_name"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token", limit: 60
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.integer "public_card_id"
    t.boolean "public_page"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.string "uid"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vanities", force: :cascade do |t|
    t.string "name"
    t.integer "vain_id"
    t.string "vain_type"
    t.index ["name"], name: "index_vanities_on_name", unique: true
    t.index ["vain_id"], name: "index_vanities_on_vain_id"
    t.index ["vain_type"], name: "index_vanities_on_vain_type"
  end
end
