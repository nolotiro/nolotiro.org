# frozen_string_literal: true
class DeleteInvalidAds < ActiveRecord::Migration
  # nolotiro v2 - DB legacy
  def up
    # there is at least an Ad without WOEID
    Ad.where(woeid_code: 0).each(&:delete)
  end

  def down
    # We will not create an invalid Ad
  end
end
