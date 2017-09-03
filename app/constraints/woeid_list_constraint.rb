# frozen_string_literal: true

#
# Route constraint for woeid ad list
#
class WoeidListConstraint
  def matches?(request)
    FullListConstraint.new.matches?(request) &&
      IdConstraint.new.matches?(request)
  end
end
