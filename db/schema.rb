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

ActiveRecord::Schema.define(version: 20131217153655) do

  create_table "ads", force: true do |t|
    t.string   "title",              limit: 100,             null: false
    t.text     "body",                                       null: false
    t.integer  "user_owner",                                 null: false
    t.integer  "type",                                       null: false
    t.integer  "woeid_code",                                 null: false
    t.datetime "created_at",                                 null: false
    t.string   "ip",                 limit: 15,              null: false
    t.string   "photo",              limit: 100
    t.integer  "status",                         default: 1, null: false
    t.integer  "comments_enabled"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
    t.integer  "readed_count"
  end

  add_index "ads", ["woeid_code"], name: "woeid", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "ads_id",                  null: false
    t.text     "body",                    null: false
    t.datetime "date_created",            null: false
    t.integer  "user_owner",              null: false
    t.string   "ip",           limit: 15, null: false
  end

  add_index "comments", ["ads_id"], name: "ads_id", using: :btree

  create_table "commentsAdCount", primary_key: "id_comment", force: true do |t|
    t.integer "count"
  end

  add_index "commentsAdCount", ["id_comment", "count"], name: "idAd_comments", using: :btree

  create_table "friendships", id: false, force: true do |t|
    t.integer "user_id",   null: false
    t.integer "friend_id", null: false
  end

  add_index "friendships", ["user_id", "friend_id"], name: "iduser_idfriend", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.integer  "thread_id",                            null: false
    t.datetime "date_created",                         null: false
    t.integer  "user_from"
    t.integer  "user_to"
    t.string   "ip",           limit: 15,              null: false
    t.string   "subject",      limit: 100,             null: false
    t.text     "body",                                 null: false
    t.integer  "readed",                   default: 0, null: false
  end

  add_index "messages", ["thread_id"], name: "thread_id", using: :btree
  add_index "messages", ["user_from"], name: "user_from", using: :btree
  add_index "messages", ["user_to"], name: "user_to", using: :btree

  create_table "messages_deleted", id: false, force: true do |t|
    t.integer "id_user",    null: false
    t.integer "id_message", null: false
  end

  add_index "messages_deleted", ["id_user", "id_message"], name: "iduser_idmessage", unique: true, using: :btree

  create_table "threads", force: true do |t|
    t.string  "subject",      limit: 100,             null: false
    t.integer "last_speaker"
    t.integer "unread",                   default: 0, null: false
  end

  add_index "threads", ["last_speaker"], name: "last_speaker", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",               limit: 32,                   null: false
    t.string   "legacy_password_hash"
    t.string   "email",                  limit: 100,                  null: false
    t.date     "created_at",                                          null: false
    t.integer  "active",                             default: 0,      null: false
    t.integer  "locked"
    t.integer  "role",                               default: 0,      null: false
    t.integer  "woeid",                              default: 766273, null: false
    t.string   "lang",                   limit: 4,                    null: false
    t.string   "encrypted_password",                 default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "ads_count",                          default: 0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
