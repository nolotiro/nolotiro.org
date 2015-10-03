ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Últimos anuncios publicados" do
          table_for Ad.includes(:user).limit(90) do 
            column :id
            column :title do |ad|
              link_to ad.title, admin_ad_path(ad)
            end
            column :user
            column :created_at do |ad|
              time_ago_in_words ad.created_at
            end
          end
        end
      end

      column do
        panel "Últimos comentarios publicados" do
          table_for Comment.includes(:ad, :user).last(30) do
            column :id
            column :body do |com|
              link_to com.body, admin_comment_path(com)
            end
            column :user
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
