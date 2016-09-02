# frozen_string_literal: true
class Announcement < ActiveRecord::Base
  has_many :dismissals, dependent: :destroy

  scope :current, -> do
    where('starts_at <= :now AND ends_at >= :now', now: Time.zone.now)
      .where('locale IS NULL OR locale = :locale', locale: I18n.locale)
  end

  def self.pending_for(user)
    join = joins <<-SQL.squish
      LEFT OUTER JOIN dismissals
      ON dismissals.announcement_id = announcements.id
      AND dismissals.user_id = #{user.id}
    SQL

    join.where(dismissals: { user_id: nil })
  end

  def self.pick_pending_for(user)
    current.pending_for(user).order(ends_at: :asc).first
  end
end
