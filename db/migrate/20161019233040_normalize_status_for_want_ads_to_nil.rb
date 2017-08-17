# frozen_string_literal: true

class NormalizeStatusForWantAdsToNil < ActiveRecord::Migration[4.2]
  def up
    change_column_null :ads, :status, true

    execute 'UPDATE ads SET status = NULL WHERE type = 2'
  end

  def down
    execute 'UPDATE ads SET status = 1 WHERE type = 2'

    change_column_null :ads, :status, false
  end
end
