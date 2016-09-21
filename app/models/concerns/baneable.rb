# frozen_string_literal: true

#
# Funcionality related to banning users
#
module Baneable
  def self.prepended(base)
    base.class_eval do
      scope :unlocked, -> { where(locked: 0) }
    end
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && locked != 1
  end

  def unlock!
    update_column('locked', 0)
  end

  def lock!
    update_column('locked', 1)
  end
end
