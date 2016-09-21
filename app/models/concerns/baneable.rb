# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  def self.prepended(base)
    base.class_eval do
      scope :unlocked, -> { where(banned_at: nil) }
    end
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && !locked?
  end

  def unlock!
    update_column('banned_at', nil)
  end

  def lock!
    update_column('banned_at', Time.zone.now)
  end

  def locked?
    !banned_at.nil?
  end

  def moderate!
    locked? ? unlock! : lock!
  end
end
