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

ActiveRecord::Schema.define(version: 20161007014256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", id: :bigserial, force: :cascade do |t|
    t.string   "title",              limit: 100,             null: false
    t.text     "body",                                       null: false
    t.integer  "user_owner",         limit: 8,               null: false
    t.integer  "type",               limit: 8,               null: false
    t.integer  "woeid_code",         limit: 8,               null: false
    t.datetime "created_at",                                 null: false
    t.string   "ip",                 limit: 15
    t.string   "photo",              limit: 100
    t.integer  "status",             limit: 8,               null: false
    t.integer  "comments_enabled"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 8
    t.datetime "image_updated_at"
    t.integer  "readed_count",       limit: 8,   default: 1
    t.datetime "published_at",                               null: false
  end

  add_index "ads", ["status"], name: "idx_16388_index_ads_on_status", using: :btree
  add_index "ads", ["user_owner"], name: "idx_16388_index_ads_on_user_owner", using: :btree
  add_index "ads", ["woeid_code"], name: "idx_16388_woeid", using: :btree

  create_table "announcements", id: :bigserial, force: :cascade do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "locale",     limit: 255
  end

  create_table "blockings", id: :bigserial, force: :cascade do |t|
    t.integer "blocker_id", limit: 8, null: false
    t.integer "blocked_id", limit: 8, null: false
  end

  add_index "blockings", ["blocked_id"], name: "idx_16407_fk_rails_8b7920d779", using: :btree
  add_index "blockings", ["blocker_id"], name: "idx_16407_fk_rails_feb742f250", using: :btree

  create_table "comments", id: :bigserial, force: :cascade do |t|
    t.integer  "ads_id",     limit: 8,  null: false
    t.text     "body",                  null: false
    t.datetime "created_at",            null: false
    t.integer  "user_owner", limit: 8,  null: false
    t.string   "ip",         limit: 15, null: false
    t.datetime "updated_at"
  end

  add_index "comments", ["ads_id"], name: "idx_16413_ads_id", using: :btree
  add_index "comments", ["user_owner"], name: "idx_16413_index_comments_on_user_owner", using: :btree

  create_table "conversations", id: :bigserial, force: :cascade do |t|
    t.string   "subject",       limit: 255, default: ""
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "originator_id", limit: 8
    t.integer  "recipient_id",  limit: 8
  end

  add_index "conversations", ["originator_id"], name: "idx_16422_index_conversations_on_originator_id", using: :btree
  add_index "conversations", ["recipient_id"], name: "idx_16422_index_conversations_on_recipient_id", using: :btree

  create_table "dismissals", id: :bigserial, force: :cascade do |t|
    t.integer "announcement_id", limit: 8
    t.integer "user_id",         limit: 8
  end

  add_index "dismissals", ["announcement_id"], name: "idx_16429_index_dismissals_on_announcement_id", using: :btree
  add_index "dismissals", ["user_id"], name: "idx_16429_index_dismissals_on_user_id", using: :btree

  create_table "friendships", id: :bigserial, force: :cascade do |t|
    t.integer "user_id",   limit: 8, null: false
    t.integer "friend_id", limit: 8, null: false
  end

  add_index "friendships", ["user_id", "friend_id"], name: "idx_16435_iduser_idfriend", unique: true, using: :btree

  create_table "identities", id: :bigserial, force: :cascade do |t|
    t.string  "provider", limit: 255
    t.string  "uid",      limit: 255
    t.integer "user_id",  limit: 8
  end

  add_index "identities", ["user_id"], name: "idx_16441_index_identities_on_user_id", using: :btree

  create_table "messages", id: :bigserial, force: :cascade do |t|
    t.text     "body"
    t.string   "subject",         limit: 255, default: ""
    t.integer  "sender_id",       limit: 8
    t.integer  "conversation_id", limit: 8
    t.datetime "updated_at",                               null: false
    t.datetime "created_at",                               null: false
  end

  add_index "messages", ["conversation_id"], name: "idx_16450_index_messages_on_conversation_id", using: :btree
  add_index "messages", ["sender_id"], name: "idx_16450_index_messages_on_sender_id", using: :btree

  create_table "receipts", id: :bigserial, force: :cascade do |t|
    t.integer  "receiver_id",     limit: 8
    t.integer  "notification_id", limit: 8,                   null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "delivery_method", limit: 255
    t.string   "message_id",      limit: 255
  end

  add_index "receipts", ["notification_id"], name: "idx_16460_index_receipts_on_notification_id", using: :btree
  add_index "receipts", ["receiver_id"], name: "idx_16460_index_receipts_on_receiver_id", using: :btree

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "username",               limit: 63,               null: false
    t.string   "legacy_password_hash",   limit: 255
    t.string   "email",                  limit: 100,              null: false
    t.date     "created_at",                                      null: false
    t.integer  "active",                             default: 0,  null: false
    t.integer  "role",                               default: 0,  null: false
    t.integer  "woeid",                  limit: 8
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 8,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "ads_count",              limit: 8,   default: 0
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        limit: 8
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "banned_at"
  end

  add_index "users", ["confirmation_token"], name: "idx_16475_index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "idx_16475_index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "idx_16475_index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "idx_16475_index_users_on_username", unique: true, using: :btree

  add_foreign_key "ads", "users", column: "user_owner", on_update: :restrict, on_delete: :restrict
  add_foreign_key "blockings", "users", column: "blocked_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "blockings", "users", column: "blocker_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "ads", column: "ads_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "users", column: "user_owner", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dismissals", "announcements", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dismissals", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "identities", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "messages", "conversations", name: "notifications_on_conversation_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "receipts", "messages", column: "notification_id", name: "receipts_on_notification_id", on_update: :restrict, on_delete: :restrict
end
