# frozen_string_literal: true
class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.references :user, index: true, foreign_key: true
    end
  end
end
