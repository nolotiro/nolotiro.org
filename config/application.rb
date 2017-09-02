# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NolotiroOrg
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :es
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = %i[ca en es fr gl it pt]
    ActionMailer::Base.layout 'mail'

    #
    # Preferred active_job adaptar
    #
    config.active_job.queue_adapter = :sidekiq

    #
    # Enable locale fallbacks
    #
    config.i18n.fallbacks = true

    #
    # Custom libraries autoloaded
    #
    config.autoload_paths += ["#{config.root}/lib"]

    #
    # Don't use TLS for SMTP since we don't yet have a valid certificate
    #
    config.action_mailer.smtp_settings = { enable_starttls_auto: false }

    #
    # Preferred schema format
    #
    config.active_record.schema_format = :sql
  end
end
