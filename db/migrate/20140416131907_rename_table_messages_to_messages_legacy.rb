# frozen_string_literal: true

class RenameTableMessagesToMessagesLegacy < ActiveRecord::Migration
  def change
    rename_table :messages, :messages_legacy
  end
end
