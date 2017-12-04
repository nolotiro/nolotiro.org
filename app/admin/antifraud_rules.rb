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
  end

  form do |f|
    f.inputs { f.input :sentence }

    f.actions
  end
end
