# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  def self.prepended(base)
    base.class_eval do
      scope :legitimate, -> { where(banned_at: nil) }
    end
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && !banned?
  end

  def unban!
    update_column('banned_at', nil)
  end

  def ban!
    update_column('banned_at', Time.zone.now)
  end

  def banned?
    !banned_at.nil?
  end

  def moderate!
    banned? ? unban! : ban!
  end
end
