# frozen_string_literal: true

ActiveAdmin.register Antifraud::Rule do
  permit_params :sentence

  config.filters = false

  index do
    column :id

    column :sentence

    column(:matched_ads) do |rule|
      link_to rule.matched_ads.count, admin_ads_path(q: { fraud_matches_antifraud_rule_id_eq: rule.id })
    end

    actions(defaults: false) do |rule|
      link_to "#{rule.enabled? ? 'Desa' : 'A'}ctivar",
              toggle_admin_antifraud_rule_path(rule),
              method: :post
    end
  end

  form do |f|
    f.inputs { f.input :sentence }

    f.actions
  end

  member_action :toggle, method: :post do
    rule = Antifraud::Rule.find(params[:id])

    rule.toggle!

    redirect_back \
      fallback_location: admin_antifraud_rules_path,
      notice: rule.enabled? ? 'Regla activada' : 'Regla desactivada'
  end
end
