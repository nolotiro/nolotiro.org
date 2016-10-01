# frozen_string_literal: true

ActiveAdmin.register Ad do
  config.sort_order = 'published_at_desc'
  config.per_page = 100

  controller do
    def scoped_collection
      params[:id] ? super : super.includes(:user)
    end
  end

  batch_action :destroy do |ids|
    Ad.where(id: ids).destroy_all

    count = ids.count
    model = active_admin_config.resource_label.downcase
    plural_model = active_admin_config.plural_resource_label(count: ids.count)
                                      .downcase

    msg = t('active_admin.batch_actions.succesfully_destroyed',
            count: count, model: model, plural_model: plural_model)

    redirect_to collection_path(q: params[:q]), notice: msg
  end

  permit_params :woeid_code, :type, :body, :title

  filter :title
  filter :body
  filter :user_username, as: :string, label: I18n.t('nlt.username')
  filter :woeid_code
  filter :type, as: :select, collection: [%w(Regalo give), %w(Busco want)]
  filter :status, as: :select, collection: [%w(Disponible available),
                                            %w(Reservado booked),
                                            %w(Entregado delivered)]
  filter :published_at

  index do
    selectable_column

    column(:title) { |ad| link_to ad.title, admin_ad_path(ad) }

    column :body

    column :user

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

    column(:city, &:woeid_name_short)

    column :published_at

    actions(defaults: false) do |ad|
      edit = link_to 'Editar', edit_admin_ad_path(ad)
      delete = link_to 'Eliminar', admin_ad_path(ad), method: :delete
      move = link_to "Mover a #{ad.give? ? 'peticiones' : 'regalos'}",
                     move_admin_ad_path(ad),
                     method: :post

      safe_join([edit, delete, move], ' ')
    end
  end

  form do |f|
    f.inputs do
      f.input :type, as: :select, include_blank: false
      f.input :title
      f.input :body
      f.input :woeid_code
    end

    f.actions
  end

  action_item :move, only: :show do
    link_to "Mover a #{ad.give? ? 'peticiones' : 'regalos'}",
            move_admin_ad_path(ad),
            method: :post
  end

  action_item :view, only: :show do
    link_to 'Ver en la web', ad_path(ad)
  end

  member_action :move, method: :post do
    ad = Ad.find(params[:id])

    ad.move!

    redirect_to admin_ads_path, notice: 'Anuncio movido'
  end
end
