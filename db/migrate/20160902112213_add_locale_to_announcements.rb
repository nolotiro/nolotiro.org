# frozen_string_literal: true

class AddLocaleToAnnouncements < ActiveRecord::Migration[5.1]
  def change
    add_column :announcements, :locale, :string, limit: 255
  end
end
