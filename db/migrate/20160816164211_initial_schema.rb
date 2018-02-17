# frozen_string_literal: true

#
# Initial DB schema
#
class InitialSchema < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'plpgsql'
    enable_extension 'pg_trgm'

    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table :active_admin_comments, id: :serial, force: :cascade do |t|
      t.string :namespace
      t.text :body
      t.string :resource_id, null: false
      t.string :resource_type, null: false
      t.integer :author_id
      t.string :author_type
      t.datetime :created_at
      t.datetime :updated_at
      t.index %i[author_type author_id], name: :index_active_admin_comments_on_author_type_and_author_id
      t.index %i[namespace], name: :index_active_admin_comments_on_namespace
      t.index %i[resource_type resource_id],
              name: :index_active_admin_comments_on_resource_type_and_resource_id
    end

    create_table :ads, force: :cascade do |t|
      t.string :title, limit: 100, null: false
      t.text :body, null: false
      t.bigint :user_owner, null: false
      t.bigint :type, null: false
      t.bigint :woeid_code, null: false
      t.datetime :created_at, null: false
      t.string :ip, limit: 15, null: false
      t.string :photo, limit: 100
      t.bigint :status, null: false
      t.integer :comments_enabled
      t.datetime :updated_at
      t.string :image_file_name, limit: 255
      t.string :image_content_type, limit: 255
      t.bigint :image_file_size
      t.datetime :image_updated_at
      t.bigint :readed_count, default: 0
      t.datetime :published_at, null: false
      t.index [:status], name: :idx_16388_index_ads_on_status
      t.index [:user_owner], name: :idx_16388_index_ads_on_user_owner
      t.index [:woeid_code], name: :idx_16388_woeid
    end

    create_table :announcements, force: :cascade do |t|
      t.text :message
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    create_table :blockings, force: :cascade do |t|
      t.bigint :blocker_id, null: false
      t.bigint :blocked_id, null: false
      t.index [:blocked_id], name: :idx_16407_fk_rails_8b7920d779
      t.index [:blocker_id], name: :idx_16407_fk_rails_feb742f250
    end

    create_table :comments, force: :cascade do |t|
      t.bigint :ads_id, null: false
      t.text :body, null: false
      t.datetime :created_at, null: false
      t.bigint :user_owner, null: false
      t.string :ip, limit: 15, null: false
      t.datetime :updated_at
      t.index [:ads_id], name: :idx_16413_ads_id
      t.index [:user_owner], name: :idx_16413_index_comments_on_user_owner
    end

    create_table :conversations, force: :cascade do |t|
      t.string :subject, limit: 255, default: ''
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.bigint :originator_id
      t.bigint :recipient_id
      t.index [:originator_id], name: :idx_16422_index_conversations_on_originator_id
      t.index [:recipient_id], name: :idx_16422_index_conversations_on_recipient_id
    end

    create_table :dismissals, force: :cascade do |t|
      t.bigint :announcement_id
      t.bigint :user_id
      t.index [:announcement_id], name: :idx_16429_index_dismissals_on_announcement_id
      t.index [:user_id], name: :idx_16429_index_dismissals_on_user_id
    end

    create_table :friendships, force: :cascade do |t|
      t.bigint :user_id, null: false
      t.bigint :friend_id, null: false
      t.index %i[user_id friend_id], name: :idx_16435_iduser_idfriend, unique: true
    end

    create_table :identities, force: :cascade do |t|
      t.string :provider, limit: 255
      t.string :uid, limit: 255
      t.bigint :user_id
      t.index [:user_id], name: :idx_16441_index_identities_on_user_id
    end

    create_table :messages, force: :cascade do |t|
      t.text :body
      t.string :subject, limit: 255, default: ''
      t.bigint :sender_id
      t.bigint :conversation_id
      t.datetime :updated_at, null: false
      t.datetime :created_at, null: false
      t.boolean :draft, default: false
      t.string :notification_code, limit: 255
      t.string :attachment, limit: 255
      t.boolean :global, default: false
      t.datetime :expires
      t.index [:conversation_id], name: :idx_16450_index_messages_on_conversation_id
      t.index [:sender_id], name: :idx_16450_index_messages_on_sender_id
    end

    create_table :receipts, force: :cascade do |t|
      t.bigint :receiver_id
      t.bigint :notification_id, null: false
      t.boolean :is_read, default: false
      t.boolean :trashed, default: false
      t.boolean :deleted, default: false
      t.string :mailbox_type, limit: 25
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :delivery_method, limit: 255
      t.string :message_id, limit: 255
      t.index [:notification_id], name: :idx_16460_index_receipts_on_notification_id
      t.index [:receiver_id], name: :idx_16460_index_receipts_on_receiver_id
    end

    create_table :users, force: :cascade do |t|
      t.string :username, limit: 63, null: false
      t.string :legacy_password_hash, limit: 255
      t.string :email, limit: 100, null: false
      t.date :created_at, null: false
      t.integer :active, default: 0, null: false
      t.integer :role, default: 0, null: false
      t.bigint :woeid
      t.string :encrypted_password, limit: 255, default: '', null: false
      t.string :reset_password_token, limit: 255
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.bigint :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip, limit: 255
      t.string :last_sign_in_ip, limit: 255
      t.bigint :ads_count, default: 0
      t.string :confirmation_token, limit: 255
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.bigint :failed_attempts
      t.string :unlock_token, limit: 255
      t.datetime :locked_at
      t.string :unconfirmed_email, limit: 255
      t.string :lang, limit: 4, null: false
      t.integer :locked
      t.index [:confirmation_token], name: :idx_16475_index_users_on_confirmation_token, unique: true
      t.index [:email], name: :idx_16475_index_users_on_email, unique: true
      t.index [:reset_password_token], name: :idx_16475_index_users_on_reset_password_token, unique: true
      t.index [:username], name: :idx_16475_index_users_on_username, unique: true
    end
    # rubocop:enable Rails/CreateTableWithTimestamps

    add_foreign_key :ads, :users, column: :user_owner, on_update: :restrict, on_delete: :restrict
    add_foreign_key :blockings, :users, column: :blocked_id, on_update: :restrict, on_delete: :restrict
    add_foreign_key :blockings, :users, column: :blocker_id, on_update: :restrict, on_delete: :restrict
    add_foreign_key :comments, :ads, column: :ads_id, on_update: :restrict, on_delete: :restrict
    add_foreign_key :comments, :users, column: :user_owner, on_update: :restrict, on_delete: :restrict
    add_foreign_key :dismissals, :announcements, on_update: :restrict, on_delete: :restrict
    add_foreign_key :dismissals, :users, on_update: :restrict, on_delete: :restrict
    add_foreign_key :identities, :users, on_update: :restrict, on_delete: :restrict

    add_foreign_key :messages,
                    :conversations,
                    name: :notifications_on_conversation_id,
                    on_update: :restrict,
                    on_delete: :restrict

    add_foreign_key :receipts,
                    :messages,
                    column: :notification_id,
                    name: :receipts_on_notification_id,
                    on_update: :restrict,
                    on_delete: :restrict
  end
end
