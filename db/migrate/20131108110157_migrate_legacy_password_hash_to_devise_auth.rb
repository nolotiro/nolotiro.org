class MigrateLegacyPasswordHashToDeviseAuth < ActiveRecord::Migration
  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def change
    #users = User.where("legacy_password_hash"!='')
    users = User.where.not(legacy_password_hash: nil)
    users.each do |i|
      i.valid_password?(i.legacy_password_hash)
    end
  end
end
