# frozen_string_literal: true

ActiveAdmin.register User do
  config.batch_actions = false
  config.clear_action_items!

  permit_params :role

  scope 'Legítimos', :legitimate, default: true
  scope 'Baneados', :banned

  filter :email
  filter :username
  filter :last_sign_in_ip
  filter :last_sign_in_at
  filter :ads_count
  filter :created_at
  filter :confirmed_at

  index do
    column :username do |user|
      link_to user.username, admin_user_path(user)
    end
    column :email
    column :confirmed_at
    column :last_sign_in_ip
    column :last_sign_in_at
    column :ads_count
    column :created_at

    actions(defaults: false) do |user|
      link_to 'Editar', edit_admin_user_path(user)
    end
  end

  action_item :view, only: :show do
    link_to 'Ver en la web', profile_path(user.username)
  end

  action_item :edit, only: :show do
    link_to 'Editar Usuario', edit_admin_user_path(user)
  end

  action_item :moderate, only: :show do
    link_to "#{user.banned? ? 'Desb' : 'B'}loquear Usuario",
            moderate_admin_user_path(user),
            method: :post
  end

  member_action :moderate, method: :post do
    user = User.find(params[:id])

    user.moderate!

    redirect_to admin_user_path(user),
                notice: "Usuario #{'des' unless user.locked?}bloqueado"
  end
end
