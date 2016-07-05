require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module NolotiroOrg
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :es
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = %i(ca de en es eu fr gl it nl pt)
    ActionMailer::Base.layout 'mail'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiq

    # Enable locale fallbacks
    config.i18n.fallbacks = true

    #
    # Custom libraries autoloaded
    #
    config.autoload_paths += %W(#{config.root}/lib)

    # Don't use TLS for SMTP since we don't yet have a valid certificate
    config.action_mailer.smtp_settings = {
      enable_starttls_auto: false
    }
  end
end
