# frozen_string_literal: true

ActiveAdmin.register Ad do
  controller do
    def scoped_collection
      super.recent_first
    end
  end

  permit_params :woeid_code, :type

  filter :title
  filter :body
  filter :user_username, as: :string
  filter :user_id, as: :string
  filter :woeid_code
  filter :type, as: :select, collection: [['Regalo', 1], ['Busco', 2]]
  filter :status, as: :select, collection: [['Disponible', 1], ['Reservado', 2], ['Entregado', 3]]
  filter :published_at

  index do
    selectable_column
    column :title do |ad|
      link_to ad.title, admin_ad_path(ad)
    end
    column :body
    column :user
    column :type_string
    column :status_class
    column :woeid_name
    column(:published_at) { |ad| ad.published_at.strftime('%d/%m/%y %H:%M') }
    actions
  end

  form do |f|
    f.inputs do
      f.input :type, as: :select,
                     collection: [['give', 1], ['want', 2]],
                     include_blank: false
      f.input :woeid_code
    end

    f.actions
  end

  action_item :view, only: :show do
    link_to 'Ver en la web', ad_path(ad)
  end
end
