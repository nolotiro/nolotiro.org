class AddConfirmableToUsers < ActiveRecord::Migration
  # Note: You can't use change, as User.update_all with fail in the down migration
  def self.up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    # add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :users, :confirmation_token, :unique => true

    # nolotiro v2 legacy - migrate users with tokens 
    # to the new confirmable model 
    #
    User.all.where.not(:token => "" ).find_each do |u|
      u.update_column(:confirmation_token, u.token)
    end

    # nolotiro v2 legacy - migrate users without tokens 
    # to the new confirmable model 
    User.all.where(:token => "" ).update_all(confirmed_at: Time.now)

    # nolotiro v2 legacy - migrate users with active = 1 but with token (???) 
    # possible legacy bug on some users
    User.where(active: 1).where(confirmed_at: nil).update_all(confirmed_at: Time.now)

    remove_columns :users, :token

  end

  def self.down

    # nolotiro v2 - legacy - dump the new migration model 
    #
    users_with_tokens = User.all.where.not(:confirmation_token => "" )
    users_with_tokens.find_each do |u|
      u.token = u.confirmation_token
      u.save
    end

    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
