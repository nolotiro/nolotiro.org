class PermitNullOnLegacyPasswordHash < ActiveRecord::Migration
  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def change
    change_column :users, :legacy_password_hash, :string, :null => true
  end
end
