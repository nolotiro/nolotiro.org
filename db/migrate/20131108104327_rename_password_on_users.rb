class RenamePasswordOnUsers < ActiveRecord::Migration
  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def change
    rename_column('users', 'password', 'legacy_password_hash')
  end
end
