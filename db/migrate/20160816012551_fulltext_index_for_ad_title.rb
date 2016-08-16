# frozen_string_literal: true

class FulltextIndexForAdTitle < ActiveRecord::Migration
  def change
    add_index :ads, :title, type: :fulltext
  end
end
