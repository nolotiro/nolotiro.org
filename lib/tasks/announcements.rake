# frozen_string_literal: true

namespace :announcements do
  desc 'Announce blocking feature'
  task blocking: :environment do
    message = <<-TXT.squish
      A partir de ahora, puedes bloquear a otros usuarios y ya no te podrán
      volver a contactar, ni ver tus regalos, comentarios o cualquier actividad
      tuya en Nolotiro. Serás invisible para ellos!
    TXT

    Announcement.create!(message: message,
                         starts_at: Time.zone.now,
                         ends_at: 2.weeks.from_now)
  end
end
