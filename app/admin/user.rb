# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :role

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
    link_to 'Ver en la web', profile_path(user.username)
  end

  action_item :moderate, only: :show do
    if user.locked?
      link_to 'Desbloquear Usuario', unlock_admin_user_path(user), method: :post
    else
      link_to 'Bloquear Usuario', lock_admin_user_path(user), method: :post
    end
  end

  member_action :unlock, method: :post do
    user = User.find(params[:id])

    user.unlock!

    redirect_to admin_user_path(user), notice: 'Usuario desbloqueado'
  end

  member_action :lock, method: :post do
    user = User.find(params[:id])

    user.lock!

    redirect_to admin_user_path(user), notice: 'Usuario bloqueado'
  end
end
