# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  extend ActiveSupport::Concern

  included do
    include Trustable

    has_many :sent_reports,
             foreign_key: :reporter_id,
             dependent: :destroy,
             class_name: 'Report'

    has_many :received_reports,
             -> { pending },
             foreign_key: :reported_id,
             class_name: 'Report'

    has_many :reported_users, through: :sent_reports, source: :reported

    scope :legitimate, -> { where(banned_at: nil) }

    scope :reported, -> do
      joined = joins <<-SQL.squish
        INNER JOIN reports
        ON reports.reported_id = users.id AND reports.dismissed_at IS NULL
      SQL

      joined.distinct
    end

    scope :banned, -> { where.not(banned_at: nil) }
    scope :recent_spammers, -> { where('banned_at >= ?', 3.months.ago) }

    delegate :max_allowed_report_score, to: :class
  end

  class_methods do
    def suspicious?(ip)
      condition = <<-SQL.squish
        last_sign_in_ip = :ip OR
        current_sign_in_ip = :ip OR
        ads.ip = :ip OR
        comments.ip = :ip
      SQL

      recent_spammers
        .joins('LEFT OUTER JOIN ads ON ads.user_owner = users.id')
        .joins('LEFT OUTER JOIN comments ON comments.user_owner = users.id')
        .where(condition, ip: ip)
        .any?
    end

    def max_allowed_report_score
      10
    end
  end

  def unban!
    update!(banned_at: nil)
  end

  def ban!
    update!(banned_at: Time.zone.now)
  end

  def ban_and_save_ip!(ip)
    update!(banned_at: Time.zone.now, last_sign_in_ip: ip)
  end

  def legitimate?
    banned_at.nil?
  end

  def banned?
    !legitimate?
  end

  def moderate!
    dismiss_reports!

    banned? ? unban! : ban!
  end

  # rubocop:disable Rails/SkipsModelValidations
  def dismiss_reports!
    received_reports.update_all(dismissed_at: Time.zone.now)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def reported_too_much?
    report_score >= self.class.max_allowed_report_score
  end

  def report!(user)
    user.received_reports.find_or_create_by!(reporter: self)

    if user.reported_too_much?
      user.ban!

      true
    else
      false
    end
  end

  def reported?(user)
    reported_users.include?(user)
  end

  def report_score
    received_reports.sum { |report| report.reporter.report_weight }
  end
end
