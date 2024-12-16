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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20181026154544) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "note"
    t.string   "browser"
    t.string   "ip_address"
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "card_emails", :force => true do |t|
    t.string   "address"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "card_emails", ["card_id"], :name => "index_card_emails_on_card_id"

  create_table "card_phones", :force => true do |t|
    t.string   "nmbr"
    t.integer  "location"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "card_phones", ["card_id"], :name => "index_card_phones_on_card_id"

  create_table "card_socials", :force => true do |t|
    t.string   "url"
    t.integer  "kind"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "card_socials", ["card_id"], :name => "index_card_socials_on_card_id"

  create_table "card_websites", :force => true do |t|
    t.string   "url"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  add_index "card_websites", ["card_id"], :name => "index_card_websites_on_card_id"

  create_table "cards", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "highlights"
    t.string   "team_name"
    t.string   "card_name"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "image"
    t.string   "background"
    t.boolean  "background_tile"
    t.integer  "membership_id"
    t.string   "background1_color"
    t.string   "background2_color"
    t.string   "address_color"
    t.string   "details_color"
    t.string   "name_color"
    t.string   "icon_color"
    t.string   "sport"
    t.string   "hometown"
    t.string   "season"
    t.string   "year"
    t.string   "league"
    t.string   "handed"
    t.string   "user_token"
    t.string   "url_alias"
    t.text     "advanced_data"
  end

  add_index "cards", ["url_alias"], :name => "index_cards_on_url_alias"
  add_index "cards", ["user_id"], :name => "index_cards_on_user_id"

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["card_id"], :name => "index_contacts_on_card_id"
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "approved"
    t.boolean  "admin"
  end

  add_index "memberships", ["team_id"], :name => "index_memberships_on_team_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "payments", :force => true do |t|
    t.string   "status"
    t.integer  "amount"
    t.string   "email"
    t.string   "transaction_number"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "stripe_customer_token"
    t.integer  "user_id"
    t.integer  "cards_purchased"
    t.integer  "card_id"
    t.datetime "paid_to"
    t.integer  "parent_id"
    t.integer  "period",                :default => 8
  end

  create_table "promo_codes", :force => true do |t|
    t.string   "code"
    t.integer  "cards",      :default => 1
    t.boolean  "used",       :default => false
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "public_kiosks", :force => true do |t|
    t.integer  "team_id"
    t.string   "background"
    t.boolean  "background_tile"
    t.string   "logo"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
  end

  add_index "public_kiosks", ["team_id"], :name => "index_public_kiosks_on_team_id"

  create_table "public_pages", :force => true do |t|
    t.boolean  "status"
    t.string   "background"
    t.string   "logo"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "card_id"
    t.boolean  "background_tile"
  end

  add_index "public_pages", ["user_id"], :name => "index_public_pages_on_user_id"

  create_table "saved_cards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shares", :force => true do |t|
    t.integer  "shareable_id"
    t.string   "shareable_type"
    t.integer  "user_id"
    t.string   "destination_email"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "message"
    t.integer  "contact_card"
  end

  create_table "stats", :force => true do |t|
    t.integer  "card_id"
    t.string   "name"
    t.string   "abbr"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "kind"
  end

  add_index "stats", ["card_id"], :name => "index_stats_on_card_id"

  create_table "team_payments", :force => true do |t|
    t.string   "status"
    t.integer  "amount"
    t.string   "email"
    t.string   "transaction_number"
    t.string   "stripe_customer_token"
    t.integer  "team_id"
    t.integer  "memberships_purchased"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "team_payments", ["team_id"], :name => "index_team_payments_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "owner_id"
    t.integer  "memberships_purchased"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "public_page"
    t.string   "username"
    t.integer  "public_card_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "cards_purchased"
    t.string   "user_agent"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vanities", :force => true do |t|
    t.string  "name"
    t.integer "vain_id"
    t.string  "vain_type"
  end

  add_index "vanities", ["name"], :name => "index_vanities_on_name", :unique => true
  add_index "vanities", ["vain_id"], :name => "index_vanities_on_vain_id"
  add_index "vanities", ["vain_type"], :name => "index_vanities_on_vain_type"

end
