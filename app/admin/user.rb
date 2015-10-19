ActiveAdmin.register User do

  filter :email
  filter :username
  filter :last_sign_in_ip
  filter :ads_count
  filter :created_at
  filter :confirmed_at
  filter :current_sign_in_at

  index do 
    selectable_column
    column :username do |user|
      link_to user.username, admin_user_path(user)
    end
    column :email 
    column :confirmed_at 
    column :last_sign_in_ip 
    column :current_sign_in_at
    column :ads_count 
    column :created_at 
    actions
  end

  action_item :view, only: :show do 
    link_to "Ver en la web", profile_path(user)
  end

end
