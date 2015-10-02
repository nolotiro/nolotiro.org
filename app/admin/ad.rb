ActiveAdmin.register Ad do

  # permit_params

  filter :title
  filter :body
  filter :user
  filter :woeid_code
  filter :type, as: :select, collection: [["Regalo", 1], ["Busco", 2]]
  filter :status, as: :select, collection: [["Disponible", 1], ["Reservado", 2], ["Entregado", 3]]

  filter :created_at

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
    column :created_at
    actions
  end

  action_item :view, only: :show do 
    link_to "Ver en la web", ad_path(ad)
  end

end
