# frozen_string_literal: true

namespace :announcements do
  desc 'Announce blocking feature'
  task blocking: :environment do
    message = <<-TXT.squish
      Ahora puedes castigar la falta de seriedad, los plantones o cualquier otro
      comportamiento que no te guste de otros usuarios de Nolotiro. Visita el
      perfil del usuario al que quieres bloquear y haz click en el enlace de
      "bloquear" que aparece. A partir de entonces eres invisible para él!
    TXT

    Announcement.create!(message: message,
                         starts_at: Time.zone.now,
                         ends_at: 2.weeks.from_now)
  end

  desc 'Translations warning as an announcement'
  task translations: :environment do
    include Rails.application.routes.url_helpers

    (I18n.available_locales - [:es]).each do |locale|
      message = <<-TXT.squish
        This language translation is in testing phase. If you find a missing or
        wrong translation, <a href=#{contact_path(locale: locale)}>please report
        it</a>
      TXT

      starts_at = Time.zone.now

      Announcement.create!(locale: locale,
                           message: message,
                           starts_at: starts_at)
    end
  end
end
