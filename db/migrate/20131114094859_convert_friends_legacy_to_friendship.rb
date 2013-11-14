class ConvertFriendsLegacyToFriendship < ActiveRecord::Migration
  def change
    # nolotirov2 legacy
    # migrate friends model to friendship model, so its easier
    rename_table :friends, :friendships
    rename_column('friendships', 'id_user', 'user_id')
    rename_column('friendships', 'id_friend', 'friend_id')
  end
end
