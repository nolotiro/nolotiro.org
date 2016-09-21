# frozen_string_literal: true

ActiveAdmin.register Ad do
  controller do
    def scoped_collection
      super.includes(:user).recent_first
    end
  end

  permit_params :woeid_code, :type, :body, :title

  scope 'No SPAM', :not_spam, default: true
  scope 'SPAM', :spam

  batch_action :toggle_spam do |ids|
    batch_action_collection.find(ids).each(&:toggle_spam!)

    redirect_to collection_path, notice: 'Feedback recibido.'
  end

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

      spam = link_to "#{'No ' if ad.spam?}SPAM",
                     mark_spam_admin_ad_path(ad, q: params[:q]),
                     method: :post

      safe_join([edit, delete, spam], ' ')
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
