# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  def self.prepended(base)
    base.class_eval do
      before_validation :remove_dot_aliases, if: %i[email_changed? email_allows_dot_aliases?]
      before_validation :remove_plus_aliases, if: %i[email_changed? email_allows_plus_aliases?]

      scope :legitimate, -> { where(banned_at: nil) }
      scope :banned, -> { where.not(banned_at: nil) }
      scope :recent_spammers, -> { where('banned_at >= ?', 3.months.ago) }
    end

    base.extend(ClassMethods)
  end

  module ClassMethods
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

  def active_for_authentication?
    super && legitimate?
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

  private

  def email_allows_dot_aliases?
    email.match?(/@gmail.com\z/)
  end

  def email_allows_plus_aliases?
    email.match?(/@(gmail|hotmail|outlook).com\z/)
  end

  def remove_dot_aliases
    email.gsub!(/\A([^@]+)/) { |identifier| identifier.delete('.') }
  end

  def remove_plus_aliases
    email.gsub!(/\+[^@]+/, '')
  end
end
