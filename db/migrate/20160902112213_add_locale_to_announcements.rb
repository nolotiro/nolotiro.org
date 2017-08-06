# frozen_string_literal: true

class AddLocaleToAnnouncements < ActiveRecord::Migration[4.2]
  def change
    add_column :announcements, :locale, :string
  end
end
