# frozen_string_literal: true
ActiveAdmin.register Ad do
  permit_params :woeid_code, :type

  filter :title
  filter :body
  filter :user_username, as: :string 
  filter :user_id, as: :string 
  filter :woeid_code
  filter :type, as: :select, collection: [['Regalo', 1], ['Busco', 2]]
  filter :status, as: :select, collection: [['Disponible', 1], ['Reservado', 2], ['Entregado', 3]]
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

  sidebar 'Acciones', only: [:show, :edit] do
    dl do
      dt '¿Es SPAM?'
      dd status_tag(ad.spam?)
    end
    ul do 
      li link_to 'Marcar como spam', mark_as_spam_admin_ad_path, method: :post, class: 'button'
      li
      li link_to 'Marcar como NO spam', mark_as_ham_admin_ad_path, method: :post, class: 'button'
    end
  end

  action_item :view, only: :show do 
    link_to 'Ver en la web', ad_path(ad)
  end

  member_action :mark_as_spam, method: :post do 
    @ad = Ad.find params[:id]
    @ad.spam!
    redirect_to admin_ad_path(@ad), notice: 'Has marcado este anuncio como SPAM'
  end

  member_action :mark_as_ham, method: :post do 
    @ad = Ad.find params[:id]
    @ad.ham!
    redirect_to admin_ad_path(@ad), notice: 'Este anuncio esta marcado como HAM (no es SPAM)'
  end

end
