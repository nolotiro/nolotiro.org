# frozen_string_literal: true

ActiveAdmin.register Ad do
  config.sort_order = 'published_at_desc'

  controller do
    def scoped_collection
      super.includes(:user)
    end
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

      safe_join([edit, delete], ' ')
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

  action_item :view, only: :show do
    link_to 'Ver en la web', ad_path(ad)
  end

  member_action :mark_spam, method: :post do
    @ad = Ad.find params[:id]

    @ad.toggle_spam!

    redirect_to admin_ads_path(q: params[:q]), notice: 'Feedback recibido'
  end
end
