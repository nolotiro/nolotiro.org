# frozen_string_literal: true

#
# Route constraint for id parameters
#
class IdConstraint
  include StringUtils

  def matches?(request)
    params = request.path_parameters

    return false unless valid_id?(params[:id])

    true
  end

  private

  def valid_id?(id)
    positive_integer?(id)
  end
end
