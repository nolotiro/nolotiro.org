# frozen_string_literal: true
ActiveAdmin.register Comment, as: 'AdComment' do
  permit_params :body

  filter :created_at

  # controller do
  #  def scoped_collection
  #    super.includes :ad, :user
  #  end
  # end

  index do
    selectable_column
    column :ad
    column :body
    column :user
    column :ip
    column :created_at
    actions
  end

  form do |f|
    f.inputs { f.input :body }

    f.actions
  end

  action_item :view, only: :show do
    link_to 'Ver en la web', ad_path(ad_comment.ad)
  end
end
