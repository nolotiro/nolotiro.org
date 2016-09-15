# frozen_string_literal: true

class AllowNilIpsInAds < ActiveRecord::Migration
  def up
    change_column_null :ads, :ip, true
    execute "UPDATE ads SET ip = NULL WHERE ip = 'unknown'"
  end

  def down
    execute "UPDATE ads SET ip = 'unknown' WHERE ip IS NULL"
    change_column_null :ads, :ip, false
  end
end
