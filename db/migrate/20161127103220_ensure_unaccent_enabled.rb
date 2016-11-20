# frozen_string_literal: true

class EnsureUnaccentEnabled < ActiveRecord::Migration
  def change
    reversible do |direction|
      direction.up do
        unless extension_enabled?('unaccent')
          raise <<-MSG.squish
            You must enable the unaccent extension. You can do so by running
            "CREATE EXTENSION unaccent;" on the current DB as a PostgreSQL
            super user.
          MSG
        end
      end
    end
  end
end
