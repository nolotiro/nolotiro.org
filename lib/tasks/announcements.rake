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

  desc 'Announce that ads about animals are forbidden'
  task animals: :environment do
    include Rails.application.routes.url_helpers

    message = <<-TXT.squish
      Hemos cambiado las reglas de nolotiro y a partir de ahora no se permiten
      anuncios de regalo ni petición de <b>animales</b>. Lee las
      <a href=#{faqs_path(locale: 'es')}>preguntas frecuentes</a> para más
      información.
    TXT

    Announcement.create!(locale: 'es',
                         message: message,
                         starts_at: Time.zone.now,
                         ends_at: 3.weeks.from_now)
  end

  desc 'Announce that ads about cars & houses are forbidden'
  task cars_and_houses: :environment do
    include Rails.application.routes.url_helpers

    faq = faqs_path(locale: 'es', anchor: 'faq9')

    message = <<-TXT.squish
      A partir de ahora no se permiten anuncios de regalo ni petición de
      <b>casas</b>, <b>coches</b> o similares. <a href=#{faq}>Más
      información</a>.
    TXT

    Announcement.create!(locale: 'es',
                         message: message,
                         starts_at: Time.zone.now,
                         ends_at: 4.weeks.from_now)
  end
end
