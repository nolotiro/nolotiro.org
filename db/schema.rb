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

ActiveRecord::Schema.define(version: 20160807150239) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "title",              limit: 100,               null: false
    t.text     "body",               limit: 65535,             null: false
    t.integer  "user_owner",         limit: 4,                 null: false
    t.integer  "type",               limit: 4,                 null: false
    t.integer  "woeid_code",         limit: 4,                 null: false
    t.datetime "created_at",                                   null: false
    t.string   "ip",                 limit: 15,                null: false
    t.string   "photo",              limit: 100
    t.integer  "status",             limit: 4,                 null: false
    t.integer  "comments_enabled",   limit: 4
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "readed_count",       limit: 4,     default: 0
    t.datetime "published_at",                                 null: false
  end

  add_index "ads", ["status"], name: "index_ads_on_status", using: :btree
  add_index "ads", ["user_owner"], name: "index_ads_on_user_owner", using: :btree
  add_index "ads", ["woeid_code"], name: "woeid", using: :btree

  create_table "announcements", force: :cascade do |t|
    t.text     "message",    limit: 65535
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "blockings", force: :cascade do |t|
    t.integer "blocker_id", limit: 4, null: false
    t.integer "blocked_id", limit: 4, null: false
  end

  add_index "blockings", ["blocked_id"], name: "fk_rails_8b7920d779", using: :btree
  add_index "blockings", ["blocker_id"], name: "fk_rails_feb742f250", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "ads_id",     limit: 4,     null: false
    t.text     "body",       limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.integer  "user_owner", limit: 4,     null: false
    t.string   "ip",         limit: 15,    null: false
    t.datetime "updated_at"
  end

  add_index "comments", ["ads_id"], name: "ads_id", using: :btree
  add_index "comments", ["user_owner"], name: "index_comments_on_user_owner", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "dismissals", force: :cascade do |t|
    t.integer "announcement_id", limit: 4
    t.integer "user_id",         limit: 4
  end

  add_index "dismissals", ["announcement_id"], name: "index_dismissals_on_announcement_id", using: :btree
  add_index "dismissals", ["user_id"], name: "index_dismissals_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id",   limit: 4, null: false
    t.integer "friend_id", limit: 4, null: false
  end

  add_index "friendships", ["user_id", "friend_id"], name: "iduser_idfriend", unique: true, using: :btree

  create_table "identities", force: :cascade do |t|
    t.string  "provider", limit: 255
    t.string  "uid",      limit: 255
    t.integer "user_id",  limit: 4
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body",                 limit: 16777215
    t.string   "subject",              limit: 255,      default: ""
    t.integer  "sender_id",            limit: 4
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id",      limit: 4
    t.boolean  "draft",                                 default: false
    t.datetime "updated_at",                                            null: false
    t.datetime "created_at",                                            null: false
    t.integer  "notified_object_id",   limit: 4
    t.string   "notified_object_type", limit: 255
    t.string   "notification_code",    limit: 255
    t.string   "attachment",           limit: 255
    t.boolean  "global",                                default: false
    t.datetime "expires"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["notified_object_id", "notified_object_type"], name: "index_messages_on_notified_object_id_and_type", using: :btree
  add_index "messages", ["sender_id", "sender_type"], name: "index_messages_on_sender_id_and_sender_type", using: :btree

  create_table "receipts", force: :cascade do |t|
    t.integer  "receiver_id",     limit: 4
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id", limit: 4,                   null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "delivery_method", limit: 255
    t.string   "message_id",      limit: 255
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree
  add_index "receipts", ["receiver_id", "receiver_type"], name: "index_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 63,               null: false
    t.string   "legacy_password_hash",   limit: 255
    t.string   "email",                  limit: 100,              null: false
    t.date     "created_at",                                      null: false
    t.integer  "active",                 limit: 4,   default: 0,  null: false
    t.integer  "locked",                 limit: 4
    t.integer  "role",                   limit: 4,   default: 0,  null: false
    t.integer  "woeid",                  limit: 4
    t.string   "lang",                   limit: 4,                null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "ads_count",              limit: 4,   default: 0
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        limit: 4
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "ads", "users", column: "user_owner"
  add_foreign_key "blockings", "users", column: "blocked_id"
  add_foreign_key "blockings", "users", column: "blocker_id"
  add_foreign_key "comments", "ads", column: "ads_id"
  add_foreign_key "comments", "users", column: "user_owner"
  add_foreign_key "dismissals", "announcements"
  add_foreign_key "dismissals", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "messages", "conversations", name: "notifications_on_conversation_id"
  add_foreign_key "receipts", "messages", column: "notification_id", name: "receipts_on_notification_id"
end
