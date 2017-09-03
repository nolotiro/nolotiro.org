# frozen_string_literal: true

#
# Route constraint for full ad list
#
class FullListConstraint
  def matches?(request)
    AdConstraint.new.matches?(request) && PageConstraint.new.matches?(request)
  end
end
