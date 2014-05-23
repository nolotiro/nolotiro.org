class AddDeletedUser < ActiveRecord::Migration

  def up
    require 'securerandom'

    u = User.create(username: "[borrado]", email: "noreply@nolotiro.org") 
    pass = SecureRandom.hex
    u.password = pass
    u.password_confirmation = pass
    u.save
  end

  def down
    u = User.find_by_username("[borrado]")
    u.delete
  end

end
