# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  def self.prepended(base)
    base.class_eval do
      scope :legitimate, -> { where(banned_at: nil) }
      scope :banned, -> { where.not(banned_at: nil) }
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
