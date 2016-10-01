# frozen_string_literal: true

ActiveAdmin.register User do
  config.batch_actions = false
  config.remove_action_item(:new)
  config.remove_action_item(:destroy)

  permit_params :role

  scope 'Legítimos', :legitimate, default: true
  scope 'Baneados', :banned

  filter :username
  filter :email
  filter :confirmed_at
  filter :last_sign_in_ip
  filter :last_sign_in_at
  filter :ads_count

  show do
    attributes_table do
      row :id
      row :username
      row :legacy_password_hash
      row :email
      row :created_at
      row :active
      row :role
      row :woeid
      row :sign_in_count
      row :last_sign_in_ip
      row :last_sign_in_at
      row :confirmed_at
      row :banned_at
      row :ads_count
    end

    panel 'Anuncios' do
      table_for user.ads.order(published_at: :desc) do
        column(:title) { |ad| link_to ad.title, admin_ad_path(ad) }

        column :published_at

        column :type do |ad|
          status_tag({ 'give' => 'green', 'want' => 'red' }[ad.type],
                     label: ad.type)
        end

        column :status do |ad|
          status_tag({ 'available' => 'green',
                       'booked' => 'orange',
                       'delivered' => 'red' }[ad.status],
                     label: ad.status)
        end

        column :body

        column :actions do |ad|
          edit = link_to 'Editar', edit_admin_ad_path(ad)
          delete = link_to 'Eliminar', admin_ad_path(ad), method: :delete

          safe_join([edit, delete], ' ')
        end
      end
    end
  end

  index do
    column(:username) { |user| link_to user.username, admin_user_path(user) }
    column :email
    column :confirmed_at
    column :last_sign_in_ip
    column :last_sign_in_at
    column :ads_count

    actions(defaults: false) do |user|
      edit = link_to 'Editar', edit_admin_user_path(user)
      moderate = link_to "#{user.banned? ? 'Desb' : 'B'}loquear",
                         moderate_admin_user_path(user),
                         method: :post

      safe_join([edit, moderate], ' ')
    end
  end

  action_item :view, only: :show do
    link_to('Ver en la web', profile_path(user.username)) if user.legitimate?
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
                notice: "Usuario #{'des' unless user.banned?}bloqueado"
  end
end
