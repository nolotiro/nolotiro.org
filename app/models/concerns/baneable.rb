# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  extend ActiveSupport::Concern

  included do
    scope :legitimate, -> { where(banned_at: nil) }
    scope :banned, -> { where.not(banned_at: nil) }
    scope :recent_spammers, -> { where('banned_at >= ?', 3.months.ago) }
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
    banned? ? unban! : ban!
  end
end
