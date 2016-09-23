# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1

  content do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel 'Últimos anuncios publicados' do
          table_for Ad.recent do
            column :id
            column :title do |ad|
              link_to ad.title, admin_ad_path(ad)
            end
            column :user do |ad|
              link_to ad.user.username, admin_user_path(ad.user)
            end
            column :published_at do |ad|
              time_ago_in_words ad.published_at
            end
          end
        end
      end

      column do
        panel 'Últimos comentarios publicados' do
          table_for Comment.recent do
            column :id
            column :body do |com|
              link_to com.body, admin_comment_path(com)
            end
            column :user do |com|
              link_to com.user.username, admin_user_path(com.user)
            end
            column :ad
            column :created_at do |com|
              time_ago_in_words com.created_at
            end
          end
        end
      end
    end
  end # content
end
