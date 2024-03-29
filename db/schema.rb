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

ActiveRecord::Schema.define(version: 20141013232902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_sessions", force: true do |t|
    t.string   "title",                                                   null: false
    t.text     "description",                                             null: false
    t.datetime "starts_at",                                               null: false
    t.decimal  "price",             precision: 5, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "host_id"
    t.string   "live_url"
    t.string   "broadcast_id"
    t.datetime "ended_at"
    t.string   "hashed_id"
    t.string   "completion_job_id"
    t.datetime "paid_out_at"
  end

  add_index "group_sessions", ["completion_job_id"], name: "index_group_sessions_on_completion_job_id", using: :btree
  add_index "group_sessions", ["deleted_at"], name: "index_group_sessions_on_deleted_at", using: :btree
  add_index "group_sessions", ["ended_at"], name: "index_group_sessions_on_ended_at", using: :btree
  add_index "group_sessions", ["hashed_id"], name: "index_group_sessions_on_hashed_id", unique: true, using: :btree
  add_index "group_sessions", ["host_id"], name: "index_group_sessions_on_host_id", using: :btree

  create_table "group_sessions_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_sessions_users", ["group_session_id"], name: "index_group_sessions_users_on_group_session_id", using: :btree
  add_index "group_sessions_users", ["user_id"], name: "index_group_sessions_users_on_user_id", using: :btree

  create_table "payment_methods", force: true do |t|
    t.integer  "last4",        null: false
    t.integer  "exp_month",    null: false
    t.integer  "exp_year",     null: false
    t.string   "remote_id",    null: false
    t.integer  "account_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_on_card"
    t.string   "brand"
  end

  add_index "payment_methods", ["account_id"], name: "index_payment_methods_on_account_id", using: :btree
  add_index "payment_methods", ["remote_id"], name: "index_payment_methods_on_remote_id", unique: true, using: :btree

  create_table "payments", force: true do |t|
    t.integer  "amount"
    t.string   "currency"
    t.integer  "account_id"
    t.integer  "group_session_id"
    t.string   "remote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_method_id"
    t.datetime "deleted_at"
    t.string   "remote_refund_id"
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id", using: :btree
  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
  add_index "payments", ["group_session_id"], name: "index_payments_on_group_session_id", using: :btree
  add_index "payments", ["payment_method_id"], name: "index_payments_on_payment_method_id", using: :btree
  add_index "payments", ["remote_id"], name: "index_payments_on_remote_id", using: :btree

  create_table "payout_accounts", force: true do |t|
    t.string   "name"
    t.string   "bank_name"
    t.integer  "last4"
    t.string   "account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "remote_id"
  end

  add_index "payout_accounts", ["account_id"], name: "index_payout_accounts_on_account_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "deleted_at"
    t.string   "first_name",           null: false
    t.string   "last_name",            null: false
    t.string   "auth_token"
    t.string   "time_zone"
    t.string   "password_reset_token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
