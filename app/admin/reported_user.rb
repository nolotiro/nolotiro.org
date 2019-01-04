# frozen_string_literal: true

ActiveAdmin.register User, as: "ReportedUser" do
  config.batch_actions = false

  actions :index

  filter :username, as: :string

  controller do
    def scoped_collection
      super.reported
    end
  end

  index do
    column(:username) do |user|
      link_to user.username, admin_user_path(user)
    end

    column :email
    column :confirmed_at
    column :ads_count

    column(:reporters) do |user|
      reporter_list = user.reporters.map do |reporter|
        link_to reporter.username, admin_user_path(reporter)
      end

      safe_join(reporter_list, " ")
    end

    column :report_score

    column(:status) do |user|
      user.banned? ? "(Auto)Bloqueado" : "Activo"
    end

    actions(defaults: false, dropdown: true) do |user|
      item "#{user.banned? ? 'Desb' : 'B'}loquear",
           moderate_admin_user_path(user),
           method: :post

      item user.banned? ? "Confirmar" : "Ignorar",
           dismiss_admin_reported_user_path(user),
           method: :post
    end
  end

  member_action :dismiss, method: :post do
    user = User.find(params[:id])

    user.dismiss_reports!

    redirect_back \
      fallback_location: admin_reported_users_path,
      notice: user.banned? ? "Bloqueo confirmado" : "Denuncias ignoradas"
  end
end
