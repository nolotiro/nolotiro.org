
# frozen_string_literal: true
NolotiroOrg::Application.config.rakismet.key = Rails.application.secrets.rakismet['key']
NolotiroOrg::Application.config.rakismet.url = Rails.application.secrets.rakismet['url']
