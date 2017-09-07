# frozen_string_literal: true

class AddGeonameIdToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :towns, :geoname_id, :integer
    add_column :states, :geoname_id, :integer
    add_column :countries, :geoname_id, :integer
  end
end
